local m=90700000
local cm=_G["c"..m]
function cm.initial_effect(c)
end
if not cm.enable_all_setname then
	cm.enable_all_setname=true
	cm._is_set_card=Card.IsSetCard
	Card.IsSetCard=function (c,...)
		return c:IsOriginalCodeRule(m) or cm._is_set_card(c,...)
	end
	cm._is_link_set_card=Card.IsLinkSetCard
	Card.IsLinkSetCard=function (c,...)
		return c:IsOriginalCodeRule(m) or cm._is_link_set_card(c,...)
	end
	cm._is_fusion_set_card=Card.IsFusionSetCard
	Card.IsFusionSetCard=function (c,...)
		return c:IsOriginalCodeRule(m) or cm._is_fusion_set_card(c,...)
	end
	cm._is_previous_set_card=Card.IsPreviousSetCard
	Card.IsPreviousSetCard=function (c,...)
		return c:IsOriginalCodeRule(m) or cm._is_previous_set_card(c,...)
	end
	cm._is_original_set_card=Card.IsOriginalSetCard
	Card.IsOriginalSetCard=function (c,...)
		return c:IsOriginalCodeRule(m) or cm._is_original_set_card(c,...)
	end
end