TESTING PLAN: 
The purpose of this testing plan is to validate that the automated infrastructure
deployment implemented using Terraform works as expected, is reproducible, and
meets functional and non-functional requirements.

1. Infrastructure Deployment Test
   Objective:
   To verify that the infrastructure can be deployed automatically and consistently.

   Test Steps:
   - Run terraform init to initialize the working directory.
   - Run terraform plan to validate the execution plan.
   - Run terraform apply to deploy the infrastructure.

   Expected Result:
   - All resources are created successfully without errors.
   - Terraform reports successful completion.

2. Resource Validation Test
   Objective:
   To ensure that all Azure resources are created correctly.

   Test Steps:
   - Verify resource groups, virtual networks, subnets, and virtual machines
     in the Azure Portal.
   - Validate that each VM is placed in the correct subnet.

   Expected Result:
   - All resources exist and match the Terraform configuration.

3. Network Connectivity Test
   Objective:
   To validate correct network segmentation and connectivity.

   Test Steps:
   - Check private IP address assignments for each virtual machine.
   - Verify Network Security Group rules are applied correctly.

   Expected Result:
   - VMs receive private IP addresses from correct subnets.
   - Network access is restricted according to security rules.

4. Logging and Monitoring Test
   Objective:
   To ensure that monitoring and logging are properly configured.

   Test Steps:
   - Query Azure Activity Logs using Log Analytics.
   - Query performance metrics (CPU, memory) from virtual machines.
   - Query Syslog entries and filter by severity.

   Expected Result:
   - Infrastructure activities appear in Activity Logs.
   - Performance metrics are collected for all virtual machines.
   - System logs are available for troubleshooting.

5. Alerting Test
   Objective:
   To validate alerting functionality.

   Test Steps:
   - Configure CPU utilization alert (>80%).
   - Verify alert rule creation and action group configuration.

   Expected Result:
   - Alert rule is successfully created and visible in Azure Monitor.
   - Notifications are triggered when conditions are met.

Conclusion:
Successful completion of all test cases confirms that the automated infrastructure
deployment is functional, observable, and suitable for enterprise environments.
--------------------------------------------------------------------------------------------------
REPORT: Infrastructure Automated Deployment
This project implements an automated cloud infrastructure deployment using
Infrastructure as Code (IaC) principles and Terraform on Microsoft Azure.

Terraform was selected as the automation tool due to its declarative syntax,
idempotent execution model, and strong support for Azure resources. The entire
infrastructure can be reproduced consistently across environments using the
same configuration files.

The deployment process consists of the following stages:
1. Initialization (terraform init), which downloads required providers and
   prepares the backend.
2. Planning (terraform plan), which generates and validates the execution plan.
3. Deployment (terraform apply), which provisions all defined resources.

The infrastructure includes multiple virtual machines deployed in isolated
subnets within a virtual network, along with network security controls,
routing, and supporting Azure services. This modular design improves
maintainability and scalability.

State management is handled using Terraform state files, which are excluded
from version control to prevent sensitive data exposure. This follows industry
best practices for secure infrastructure automation.

To ensure observability, Azure Monitor and Log Analytics Workspace were
integrated into the deployment. Infrastructure activities are captured using
Azure Activity Logs, while system-level and performance logs are collected
from virtual machines. This enables real-time monitoring, auditing, and
effective troubleshooting.

The automated deployment approach reduces manual configuration errors,
improves deployment speed, and ensures consistency across environments.
This solution demonstrates a production-ready, enterprise-grade infrastructure
automation strategy.


------------------------------------------------------------

Azure Enterprise Network Architecture – Design Decisions
Overview

This repository contains an enterprise-style Azure infrastructure deployed using Terraform.
The goal of this project is to design a secure, segmented, and monitored cloud architecture that follows real-life enterprise principles while remaining within an academic scope and cost limitations.

The architecture is based on a three-tier model (Web / App / DB) with centralized logging, controlled ingress and egress, and strong network segmentation.

Networking Components – Usage and Design Rationale

Below is a detailed explanation of which Azure networking components are used, partially used, or intentionally not used, along with the reasoning.

1. Network Foundation
Components
Virtual Network (VNet)
Subnets
VNet Peering
Virtual WAN
Usage
✅ Used
Virtual Network (VNet)
Acts as the main network boundary for all resources.
Subnets (Web, App, DB)
Provide logical isolation between tiers and allow security enforcement via NSGs and routing.
❌ Not Used
VNet Peering – All resources are deployed within a single VNet.
Virtual WAN – Not required for a single-region, single-VNet architecture.
Reasoning:
The project does not require multi-region connectivity or hub-and-spoke topology at this stage.


2. Hybrid Connectivity
Components
ExpressRoute
VPN Gateway
Route Server
Usage
❌ Not Used
Reasoning:
This is a cloud-only academic project with no real on-premises environment.
ExpressRoute and VPN Gateway were intentionally excluded due to cost and scope.


3. Perimeter Security
Components
Azure Firewall Premium
Firewall Manager
DDoS Protection
Usage
✅ Used
Azure DDoS Protection (Standard)
Protects public-facing resources against volumetric attacks.
❌ Not Used
Azure Firewall Premium
Firewall Manager
Reasoning:
Security is enforced using NSGs and private subnets. Firewall Premium was excluded due to cost and scope constraints.


4. Micro-Segmentation
Components
Network Security Groups (NSG)
Application Security Groups (ASG)
User Defined Routes (UDR)
Virtual Network Manager
Usage
✅ Used
NSGs – Strict inbound and inter-subnet traffic control.
UDRs – Control outbound traffic and enforce NAT-based egress.
❌ Not Used
ASGs – Skipped to keep configuration simpler.
Virtual Network Manager – Not required for a single-VNet design.


5. Private Connectivity
Components
Private Link
Private Endpoints
Private DNS Zones
DNS Private Resolver
Usage
✅ Used
Azure Private DNS Resolver – Enables internal DNS resolution inside the VNet.
❌ Not Used
Private Endpoints / Private Link – No PaaS services are currently used.
Service Endpoints – Not required.


6. Ingress Protection
Components
Application Gateway (WAF)
Azure Front Door
Load Balancer
Usage
✅ Used
Azure Load Balancer (Standard)
Distributes HTTP traffic to Web VMs.
❌ Not Used
Application Gateway (WAF) – Excluded due to cost and complexity.
Azure Front Door – Global routing not required.


7. Monitoring and Logging
Components
Azure Monitor
Log Analytics Workspace
Network Watcher
Traffic Analytics
Connection Monitor
Usage
✅ Implemented
Azure Monitor + Log Analytics
Subscription Activity Logs
VM Syslog
VM Performance Metrics (CPU, Memory)
❌ Not Used
Traffic Analytics
Connection Monitor
Reasoning:
Centralized logging is sufficient to prove observability and auditability for this project.


8. Administrative Access
Components
Azure Bastion
Just-In-Time (JIT) VM Access
Usage
🟡 Partially Planned
Architecture supports Bastion, but not fully deployed due to cost.
JIT not enabled; access is restricted using NSGs and SSH keys.


9. DNS
Components
Azure DNS
Private DNS Zones
DNS Private Resolver
Usage
✅ Used
Azure DNS (Public) – Public name resolution.
Private DNS Resolver – Internal DNS resolution.


10. NAT / Egress
Components
Virtual Network NAT Gateway
Usage
✅ Used
NAT Gateway – Secure outbound internet access for App and DB subnets without public IPs.

Summary
This architecture demonstrates:
Strong network segmentation
Controlled ingress and egress
Centralized logging and monitoring
Cost-aware enterprise design
Some enterprise-grade components were intentionally excluded to keep the solution aligned with academic scope, cost constraints, and deployment complexity.

Notes on PCI Compliance
The current implementation demonstrates foundational security concepts, but it is not fully PCI DSS compliant.
Additional components such as WAF, Firewall Premium, private endpoints, encryption controls, and audit hardening would be required for a production PCI environment.
