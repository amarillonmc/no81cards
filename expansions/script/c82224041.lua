local m=82224041
local cm=_G["c"..m]
cm.name="魔灵王·斯摩亚蒂"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_DARK),2)  
	c:EnableReviveLimit()
	--damage  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_DAMAGE)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCountLimit(1,82204041)
	e1:SetCondition(cm.damcon)  
	e1:SetOperation(cm.damop)  
	c:RegisterEffect(e1)
	--bu si mo ling wang, yi miao jiu liang liang
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)  
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetCountLimit(1,m)  
	e2:SetCondition(cm.spcon)  
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2)  
	--cannot link material  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)  
	e3:SetValue(1)  
	c:RegisterEffect(e3)  
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function cm.damcon2(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetTurnPlayer()==tp  
end 
function cm.damop(e,tp,eg,ep,ev,re,r,rp)  
	local e2=Effect.CreateEffect(e:GetHandler()) 
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)  
	e2:SetCountLimit(1)   
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)  
	e2:SetCondition(cm.damcon2)
	e2:SetOperation(cm.damop2)  
	Duel.RegisterEffect(e2,tp)   
end  
function cm.damop2(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Damage(1-tp,3000,REASON_EFFECT)  
end  
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  