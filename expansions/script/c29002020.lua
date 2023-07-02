--方舟骑士·年
c29002020.named_with_Arknight=1
function c29002020.initial_effect(c)
	c:EnableReviveLimit()  
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29002020,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c29002020.sprcon)
	e1:SetOperation(c29002020.sprop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c29002020.splimit)
	c:RegisterEffect(e2) 
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(c29002020.efilter)
	c:RegisterEffect(e3)  
end 
function c29002020.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c29002020.hspfilter(c,ft,tp)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
		and (ft>0 or c:IsControler(tp)) and (c:IsControler(tp) or c:IsFaceup())
end
function c29002020.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local x=Duel.GetActivityCount(tp,ACTIVITY_SUMMON)+Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)+Duel.GetActivityCount(1-tp,ACTIVITY_SUMMON)+Duel.GetActivityCount(1-tp,ACTIVITY_SPSUMMON)
	return x>=12 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and Duel.CheckReleaseGroup(tp,c29002020.mfilter,3,nil,ft,tp)
end
function c29002020.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,c29002020.mfilter,3,3,nil,ft,tp)
	Duel.Release(g,REASON_RULE)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c29002020.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end