//
//  IncludeStubs.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/10/18.
//

let one_include = """
[
    {
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    }
]
""".data(using: .utf8)!

let two_same_type_includes = """
[
    {
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
        {
        "type": "test_entity1",
        "id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
        "attributes": {
            "foo": "World",
            "bar": 456
        }
    }
]

""".data(using: .utf8)!

let two_different_type_includes = """
[
    {
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
    {
        "type": "test_entity2",
        "id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
        "attributes": {
            "foo": "World",
            "bar": 456
        },
        "relationships": {
            "entity1": {
                "data": {
                    "type": "test_entity1",
                    "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
                }
            }
        }
    }
]

""".data(using: .utf8)!

let three_different_type_includes = """
[
	{
		"type": "test_entity1",
		"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
		"attributes": {
			"foo": "Hello",
			"bar": 123
		}
	},
	{
		"type": "test_entity2",
		"id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
		"attributes": {
			"foo": "World",
			"bar": 456
		},
		"relationships": {
			"entity1": {
				"data": {
					"type": "test_entity1",
					"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
				}
			}
		}
	},
	{
		"type": "test_entity4",
		"id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
	}
]
""".data(using: .utf8)!

let four_different_type_includes = """
[
	{
		"type": "test_entity1",
		"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
		"attributes": {
			"foo": "Hello",
			"bar": 123
		}
	},
	{
		"type": "test_entity2",
		"id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
		"attributes": {
			"foo": "World",
			"bar": 456
		},
		"relationships": {
			"entity1": {
				"data": {
					"type": "test_entity1",
					"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
				}
			}
		}
	},
    {
        "type": "test_entity4",
        "id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
    },
	{
		"type": "test_entity6",
		"id": "11113B69-4DF1-467F-B52E-B0C9E44FC444",
		"relationships": {
			"entity4": {
				"data": {
					"type": "test_entity4",
					"id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
				}
			}
		}
	}
]
""".data(using: .utf8)!

let five_different_type_includes = """
[
	{
		"type": "test_entity1",
		"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
		"attributes": {
			"foo": "Hello",
			"bar": 123
		}
	},
	{
		"type": "test_entity2",
		"id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
		"attributes": {
			"foo": "World",
			"bar": 456
		},
		"relationships": {
			"entity1": {
				"data": {
					"type": "test_entity1",
					"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
				}
			}
		}
	},
	{
		"type": "test_entity3",
		"id": "11223B69-4DF1-467F-B52E-B0C9E44FC443",
		"relationships": {
			"entity1": {
				"data": {
					"type": "test_entity1",
					"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
				}
			},
			"entity2": {
				"data": [
					{
						"type": "test_entity2",
						"id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333"
					}
				]
			}
		}
	},
	{
		"type": "test_entity6",
		"id": "11113B69-4DF1-467F-B52E-B0C9E44FC444",
		"relationships": {
			"entity4": {
				"data": {
					"type": "test_entity4",
					"id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
				}
			}
		}
	},
	{
		"type": "test_entity4",
		"id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
	}
]
""".data(using: .utf8)!

let six_different_type_includes = """
[
	{
		"type": "test_entity1",
		"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
		"attributes": {
			"foo": "Hello",
			"bar": 123
		}
	},
	{
		"type": "test_entity2",
		"id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
		"attributes": {
			"foo": "World",
			"bar": 456
		},
		"relationships": {
			"entity1": {
				"data": {
					"type": "test_entity1",
					"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
				}
			}
		}
	},
	{
		"type": "test_entity3",
		"id": "11223B69-4DF1-467F-B52E-B0C9E44FC443",
		"relationships": {
			"entity1": {
				"data": {
					"type": "test_entity1",
					"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
				}
			},
			"entity2": {
				"data": [
					{
						"type": "test_entity2",
						"id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333"
					}
				]
			}
		}
	},
	{
		"type": "test_entity6",
		"id": "11113B69-4DF1-467F-B52E-B0C9E44FC444",
		"relationships": {
			"entity4": {
				"data": {
					"type": "test_entity4",
					"id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
				}
			}
		}
	},
	{
		"type": "test_entity5",
		"id": "A24B3B69-4DF1-467F-B52E-B0C9E44F436A"
	},
	{
		"type": "test_entity4",
		"id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
	}
]
""".data(using: .utf8)!

let seven_different_type_includes = """
[
	{
		"type": "test_entity1",
		"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
		"attributes": {
			"foo": "Hello",
			"bar": 123
		}
	},
	{
		"type": "test_entity2",
		"id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
		"attributes": {
			"foo": "World",
			"bar": 456
		},
		"relationships": {
			"entity1": {
				"data": {
					"type": "test_entity1",
					"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
				}
			}
		}
	},
	{
		"type": "test_entity3",
		"id": "11223B69-4DF1-467F-B52E-B0C9E44FC443",
		"relationships": {
			"entity1": {
				"data": {
					"type": "test_entity1",
					"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
				}
			},
			"entity2": {
				"data": [
					{
						"type": "test_entity2",
						"id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333"
					}
				]
			}
		}
	},
	{
		"type": "test_entity6",
		"id": "11113B69-4DF1-467F-B52E-B0C9E44FC444",
		"relationships": {
			"entity4": {
				"data": {
					"type": "test_entity4",
					"id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
				}
			}
		}
	},
	{
		"type": "test_entity5",
		"id": "A24B3B69-4DF1-467F-B52E-B0C9E44F436A"
	},
	{
		"type": "test_entity4",
		"id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
	},
	{
		"type": "test_entity7",
		"id": "364B3B69-4DF1-222F-B52E-B0C9E44F666E"
	}
]
""".data(using: .utf8)!

let eight_different_type_includes = """
[
	{
		"type": "test_entity1",
		"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
		"attributes": {
			"foo": "Hello",
			"bar": 123
		}
	},
	{
		"type": "test_entity2",
		"id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
		"attributes": {
			"foo": "World",
			"bar": 456
		},
		"relationships": {
			"entity1": {
				"data": {
					"type": "test_entity1",
					"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
				}
			}
		}
	},
	{
		"type": "test_entity3",
		"id": "11223B69-4DF1-467F-B52E-B0C9E44FC443",
		"relationships": {
			"entity1": {
				"data": {
					"type": "test_entity1",
					"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
				}
			},
			"entity2": {
				"data": [
					{
						"type": "test_entity2",
						"id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333"
					}
				]
			}
		}
	},
	{
		"type": "test_entity6",
		"id": "11113B69-4DF1-467F-B52E-B0C9E44FC444",
		"relationships": {
			"entity4": {
				"data": {
					"type": "test_entity4",
					"id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
				}
			}
		}
	},
	{
		"type": "test_entity5",
		"id": "A24B3B69-4DF1-467F-B52E-B0C9E44F436A"
	},
	{
		"type": "test_entity4",
		"id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
	},
	{
		"type": "test_entity7",
		"id": "364B3B69-4DF1-222F-B52E-B0C9E44F666E"
	},
	{
		"type": "test_entity8",
		"id": "364B3B69-4DF1-222F-B52E-B0C9E44F266F"
	}
]
""".data(using: .utf8)!

let nine_different_type_includes = """
[
	{
		"type": "test_entity1",
		"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
		"attributes": {
			"foo": "Hello",
			"bar": 123
		}
	},
	{
		"type": "test_entity2",
		"id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
		"attributes": {
			"foo": "World",
			"bar": 456
		},
		"relationships": {
			"entity1": {
				"data": {
					"type": "test_entity1",
					"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
				}
			}
		}
	},
	{
		"type": "test_entity3",
		"id": "11223B69-4DF1-467F-B52E-B0C9E44FC443",
		"relationships": {
			"entity1": {
				"data": {
					"type": "test_entity1",
					"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
				}
			},
			"entity2": {
				"data": [
					{
						"type": "test_entity2",
						"id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333"
					}
				]
			}
		}
	},
	{
		"type": "test_entity6",
		"id": "11113B69-4DF1-467F-B52E-B0C9E44FC444",
		"relationships": {
			"entity4": {
				"data": {
					"type": "test_entity4",
					"id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
				}
			}
		}
	},
	{
		"type": "test_entity5",
		"id": "A24B3B69-4DF1-467F-B52E-B0C9E44F436A"
	},
	{
		"type": "test_entity4",
		"id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
	},
	{
		"type": "test_entity7",
		"id": "364B3B69-4DF1-222F-B52E-B0C9E44F666E"
	},
	{
		"type": "test_entity8",
		"id": "364B3B69-4DF1-222F-B52E-B0C9E44F266F"
	},
	{
		"type": "test_entity9",
		"id": "364B3B69-4DF1-218F-B52E-B0C9E44F2661"
	}
]
""".data(using: .utf8)!

let ten_different_type_includes = """
[
    {
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
    {
        "type": "test_entity2",
        "id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
        "attributes": {
            "foo": "World",
            "bar": 456
        },
        "relationships": {
            "entity1": {
                "data": {
                    "type": "test_entity1",
                    "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
                }
            }
        }
    },
    {
        "type": "test_entity3",
        "id": "11223B69-4DF1-467F-B52E-B0C9E44FC443",
        "relationships": {
            "entity1": {
                "data": {
                    "type": "test_entity1",
                    "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
                }
            },
            "entity2": {
                "data": [
                    {
                        "type": "test_entity2",
                        "id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333"
                    }
                ]
            }
        }
    },
    {
        "type": "test_entity6",
        "id": "11113B69-4DF1-467F-B52E-B0C9E44FC444",
        "relationships": {
            "entity4": {
                "data": {
                    "type": "test_entity4",
                    "id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
                }
            }
        }
    },
    {
        "type": "test_entity5",
        "id": "A24B3B69-4DF1-467F-B52E-B0C9E44F436A"
    },
    {
        "type": "test_entity4",
        "id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
    },
    {
        "type": "test_entity7",
        "id": "364B3B69-4DF1-222F-B52E-B0C9E44F666E"
    },
    {
        "type": "test_entity8",
        "id": "364B3B69-4DF1-222F-B52E-B0C9E44F266F"
    },
    {
        "type": "test_entity9",
        "id": "364B3B69-4DF1-218F-B52E-B0C9E44F2661"
    },
    {
        "type": "test_entity10",
        "id": "264B3B69-4DF1-212F-B52E-B0C9E44F2660"
    }
]
""".data(using: .utf8)!

let eleven_different_type_includes = """
[
    {
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
    {
        "type": "test_entity2",
        "id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
        "attributes": {
            "foo": "World",
            "bar": 456
        },
        "relationships": {
            "entity1": {
                "data": {
                    "type": "test_entity1",
                    "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
                }
            }
        }
    },
    {
        "type": "test_entity3",
        "id": "11223B69-4DF1-467F-B52E-B0C9E44FC443",
        "relationships": {
            "entity1": {
                "data": {
                    "type": "test_entity1",
                    "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
                }
            },
            "entity2": {
                "data": [
                    {
                        "type": "test_entity2",
                        "id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333"
                    }
                ]
            }
        }
    },
    {
        "type": "test_entity6",
        "id": "11113B69-4DF1-467F-B52E-B0C9E44FC444",
        "relationships": {
            "entity4": {
                "data": {
                    "type": "test_entity4",
                    "id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
                }
            }
        }
    },
    {
        "type": "test_entity5",
        "id": "A24B3B69-4DF1-467F-B52E-B0C9E44F436A"
    },
    {
        "type": "test_entity4",
        "id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
    },
    {
        "type": "test_entity7",
        "id": "364B3B69-4DF1-222F-B52E-B0C9E44F666E"
    },
    {
        "type": "test_entity8",
        "id": "364B3B69-4DF1-222F-B52E-B0C9E44F266F"
    },
    {
        "type": "test_entity9",
        "id": "364B3B69-4DF1-218F-B52E-B0C9E44F2661"
    },
    {
        "type": "test_entity10",
        "id": "264B3B69-4DF1-212F-B52E-B0C9E44F2660"
    },
    {
        "type": "test_entity11",
        "id": "264B3B69-4DF3-212F-B32E-A0C9E44F26C0B"
    }
]
""".data(using: .utf8)!


let three_includes_one_missing_attributes = """
[
    {
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
    {
        "type": "test_entity4",
        "id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
    },
    {
        "type": "test_entity2",
        "id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
        "attributes": {
            "bar": 456
        },
        "relationships": {
            "entity1": {
                "data": {
                    "type": "test_entity1",
                    "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
                }
            }
        }
    }
]
""".data(using: .utf8)!

let six_includes_one_bad_type = """
[
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
    {
        "type": "test_entity2",
        "id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
        "attributes": {
            "foo": "World",
            "bar": 456
        },
        "relationships": {
            "entity1": {
                "data": {
                    "type": "test_entity1",
                    "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
                }
            }
        }
    },
    {
        "type": "test_entity4",
        "id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
    },
    {
        "type": "test_entity6",
        "id": "11113B69-4DF1-467F-B52E-B0C9E44FC444",
        "relationships": {
            "entity4": {
                "data": {
                    "type": "test_entity4",
                    "id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
                }
            }
        }
    }
]
""".data(using: .utf8)!

let eleven_includes_one_bad_type = """
[
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
    {
        "type": "test_entity2",
        "id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
        "attributes": {
            "foo": "World",
            "bar": 456
        },
        "relationships": {
            "entity1": {
                "data": {
                    "type": "test_entity1",
                    "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
                }
            }
        }
    },
    {
        "type": "test_entity4",
        "id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
    },
    {
        "type": "test_entity6",
        "id": "11113B69-4DF1-467F-B52E-B0C9E44FC444",
        "relationships": {
            "entity4": {
                "data": {
                    "type": "test_entity4",
                    "id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
                }
            }
        }
    }
]
""".data(using: .utf8)!

let twenty_two_includes_one_bad_type = """
[
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
{
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "attributes": {
            "foo": "Hello",
            "bar": 123
        }
    },
    {
        "type": "test_entity2",
        "id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
        "attributes": {
            "foo": "World",
            "bar": 456
        },
        "relationships": {
            "entity1": {
                "data": {
                    "type": "test_entity1",
                    "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
                }
            }
        }
    },
    {
        "type": "test_entity4",
        "id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
    },
    {
        "type": "test_entity6",
        "id": "11113B69-4DF1-467F-B52E-B0C9E44FC444",
        "relationships": {
            "entity4": {
                "data": {
                    "type": "test_entity4",
                    "id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
                }
            }
        }
    }
]
""".data(using: .utf8)!
