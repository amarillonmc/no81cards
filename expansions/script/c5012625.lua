--僧正
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	aux.AddCodeList(c,5012604)
	c:SetUniqueOnField(1,1,id)
	c:EnableReviveLimit()
	--cannot fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(0xff)
	e5:SetValue(s.effectfilter)
	c:RegisterEffect(e5)
	--spsummon proc
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCondition(s.hspcon)
	e6:SetTarget(s.hsptg)
	e6:SetValue(SUMMON_TYPE_RITUAL)
	e6:SetOperation(s.hspop)
	c:RegisterEffect(e6)
	--disable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EVENT_CHAIN_SOLVING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.discon)
	e7:SetOperation(s.disop)
	c:RegisterEffect(e7)
	--cannot release
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_UNRELEASABLE_SUM)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e9)
	--做超量素材时送去墓地
	local e11=Effect.CreateEffect(c)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e11:SetCode(EVENT_ADJUST)
	e11:SetCountLimit(13,id)
	e11:SetOperation(s.rmop)
	Duel.RegisterEffect(e11,0)
	--control
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e10)
	--maintain
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--e17:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e17:SetCode(EVENT_PHASE+PHASE_END)
	e17:SetRange(LOCATION_MZONE)
	e17:SetCountLimit(1)
	e17:SetCondition(s.mtcon)
	e17:SetOperation(s.mtop)
	c:RegisterEffect(e17)
end
function s.rmop(e)
	local g=Duel.GetOverlayGroup(0,LOCATION_MZONE,LOCATION_MZONE)
	local tgg=g:Filter(Card.IsCode,nil,id)
	if tgg and #tgg>0 then

		Duel.SendtoGrave(tgg,REASON_EFFECT)
	end
end
function s.ndsfilter(c)
	return c:IsFaceup() and c:IsCode(5012604)
end
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.ndsfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsAbleToRemove() then return end
	Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
end
function s.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler()==e:GetHandler()
end
function s.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g,tp)>0
end
function s.hspfilter(c)
	return not c:IsLocation(LOCATION_GRAVE)
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetRitualMaterial(tp):Filter(s.hspfilter,nil)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_REMOVED,0,c)
	--local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_REMOVED,0,c)
	local b1=aux.RitualUltimateFilter(c,nil,e,tp,mg,nil,Card.GetLevel,"Greater")
	local b2=#g>10 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	return b2 or b1
end
function s.tgfilter(c)
	return c:IsAbleToGraveAsCost()and c.MoJin==true
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local sg=nil
	local mg=Duel.GetRitualMaterial(tp):Filter(s.hspfilter,nil)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_REMOVED,0,c)
	--local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_REMOVED,0,c)
	local b1=aux.RitualUltimateFilter(c,nil,e,tp,mg,nil,Card.GetLevel,"Greater")
	local b2=#g>10 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if b1 and (#g<11 or Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,0))==1) then
		::cancel::
		mg=mg:Filter(Card.IsCanBeRitualMaterial,c,c)
		if c.mat_filter then
			mg=mg:Filter(c.mat_filter,c,tp)
		else
			mg:RemoveCard(c)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(c,c:GetLevel(),"Greater")
		sg=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,c:GetLevel(),tp,c,c:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not sg then goto cancel end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		sg=g:Select(tp,11,11,nil)
	end	
	if sg then
		e:SetLabel(sel)
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	c:SetMaterial(sg)
	if sel==1 then
		Duel.Release(sg,REASON_COST+REASON_MATERIAL+REASON_RITUAL)
	else 
		Duel.SendtoGrave(sg,REASON_COST+REASON_MATERIAL+REASON_RITUAL)
	end	
	sg:DeleteGroup()
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local rc=re:GetHandler()
	return re:GetActivateLocation()~=LOCATION_MZONE and re:GetActivateLocation()~=LOCATION_SZONE and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end