
from typing import Tuple

import torch
import torchvision

import qai_hub as hub

# Using pre-trained MobileNet
torch_model = torchvision.models.mobilenet_v2(pretrained=True)
torch_model.eval()

# Trace model
input_shape: Tuple[int, ...] = (1, 3, 224, 224)
example_input = torch.rand(input_shape)
pt_model = torch.jit.trace(torch_model, example_input)

# Profile model on a specific device
@rscompile_job, profile_job = hub.submit_compile_and_profile_jobs(
    pt_model,
    name="MyMobileNet",
    device=hub.Device("Samsung Galaxy S23 Ultra"),
    input_specs=dict(image=input_shape),
)
