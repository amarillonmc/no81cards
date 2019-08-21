--甲板守卫者
local m=14010084
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(cm.catg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Shuffle your Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.shcon)
	e2:SetOperation(cm.shop)
	c:RegisterEffect(e2)
end
function cm.matfilter(c)
	return c:IsDefensePos() and c:IsFaceup()
end
function cm.catg(e,c)
	return e:GetHandler()==c or e:GetHandler():GetLinkedGroup():IsContains(c)
end
function cm.shcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(tp)
end
