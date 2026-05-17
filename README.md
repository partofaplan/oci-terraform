# OCI Terraform

Terraform framework for Oracle Cloud Infrastructure. Provisions a VCN with public/private subnets, compute instances, object storage, and block volumes.

## Repository layout

```
.
├── main.tf                    # Root module — wires modules together
├── variables.tf               # All input variables
├── outputs.tf                 # Root-level outputs
├── providers.tf               # OCI provider configuration
├── versions.tf                # Terraform / provider version pins
├── terraform.tfvars.example   # Copy → terraform.tfvars and fill in
└── modules/
    ├── networking/            # VCN, subnets, gateways, route tables, security lists
    ├── compute/               # Flex-shape compute instances
    └── storage/               # Object storage bucket + block volume
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5
- An active [Oracle Cloud account](https://cloud.oracle.com)
- OCI CLI (optional but recommended): `brew install oci-cli`

---

## Setting up OCI access

### 1. Locate your tenancy and user OCIDs

1. Sign in to the [OCI Console](https://cloud.oracle.com).
2. Open the **Profile** menu (top-right) → **Tenancy: \<name\>**.
   - Copy the **OCID** shown on the Tenancy detail page — this is your `tenancy_ocid`.
3. Open the **Profile** menu → **My profile**.
   - Copy the **OCID** — this is your `user_ocid`.

### 2. Generate an API key pair

Terraform authenticates to OCI using a PEM key pair. Generate one now if you don't have one:

```bash
mkdir -p ~/.oci
openssl genrsa -out ~/.oci/oci_api_key.pem 2048
chmod 600 ~/.oci/oci_api_key.pem
openssl rsa -pubout -in ~/.oci/oci_api_key.pem -out ~/.oci/oci_api_key_public.pem
```

### 3. Upload the public key to OCI

1. In the OCI Console, navigate to **Profile** → **My profile** → **API keys**.
2. Click **Add API key** → **Paste a public key**.
3. Paste the contents of `~/.oci/oci_api_key_public.pem`.
4. Click **Add**. OCI will display a **configuration file preview** — copy the `fingerprint` value (format: `xx:xx:xx:…`).

### 4. (Optional) Verify with the OCI CLI

If you have the OCI CLI installed, validate your credentials before running Terraform:

```bash
oci setup config        # interactive wizard — writes ~/.oci/config
oci iam region list     # should return a list of regions
```

The wizard also auto-generates the key pair and uploads it for you if preferred.

### 5. Choose or create a compartment

Resources are created inside a **compartment**. You can use the root compartment (same OCID as `tenancy_ocid`) or create a dedicated one:

1. OCI Console → **Identity & Security** → **Compartments** → **Create Compartment**.
2. Copy the compartment **OCID** for `compartment_ocid`.

### 6. Find a platform image OCID

Compute instances need a source image. To find Oracle Linux image OCIDs for your region:

```bash
oci compute image list \
  --compartment-id <tenancy_ocid> \
  --operating-system "Oracle Linux" \
  --operating-system-version "8" \
  --shape VM.Standard.E4.Flex \
  --query 'data[0].id' \
  --raw-output
```

Or browse the [OCI Marketplace platform images page](https://docs.oracle.com/en-us/iaas/images/).

---

## Deploying

### 1. Configure variables

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and fill in every value (see comments in the file). It is gitignored and must never be committed.

### 2. Initialise Terraform

```bash
terraform init
```

### 3. Preview the plan

```bash
terraform plan
```

### 4. Apply

```bash
terraform apply
```

Type `yes` when prompted. Terraform prints the output values (VCN ID, instance IPs, etc.) when the apply completes.

### 5. Destroy

```bash
terraform destroy
```

---

## What gets created

| Resource | Description |
|---|---|
| VCN | Virtual Cloud Network with the configured CIDR |
| Public subnet | Internet-accessible subnet; routes traffic via Internet Gateway |
| Private subnet | No public IPs; outbound traffic via NAT Gateway; OCI services via Service Gateway |
| Internet Gateway | Allows inbound/outbound internet traffic for the public subnet |
| NAT Gateway | Outbound-only internet access for the private subnet |
| Service Gateway | Private path to OCI services (Object Storage, etc.) without internet traversal |
| Security lists | Least-privilege rules: public subnet allows 80/443 in; private subnet allows VCN-internal traffic only |
| Compute instance(s) | Flex-shape VM(s) placed in the private subnet |
| Object Storage bucket | Versioned, private-by-default bucket |
| Block volume | Unattached block volume (attach to an instance post-deploy as needed) |

## Remote state (recommended for teams)

Store state in OCI Object Storage instead of locally:

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket                      = "<your-bucket-name>"
    key                         = "terraform.tfstate"
    region                      = "us-ashburn-1"
    endpoint                    = "https://<namespace>.compat.objectstorage.<region>.oraclecloud.com"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
```

OCI Object Storage is S3-compatible. Generate a **Customer Secret Key** in **My profile** → **Customer secret keys** and set `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` in your environment.

## Security notes

- `terraform.tfvars` and `*.pem` files are gitignored. Never commit credentials.
- The private subnet blocks all inbound traffic from the internet by design. To reach instances, use a bastion or OCI Bastion Service.
- Rotate your API key regularly under **My profile** → **API keys**.
