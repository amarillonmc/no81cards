--湮潮使·澪铃
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x452)
	aux.AddCodeList(c,0x452)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetValue(SUMMON_TYPE_RITUAL)
	e0:SetCondition(s.sprcon)
	e0:SetTarget(s.sprtg)
	e0:SetOperation(s.sprop)
	c:RegisterEffect(e0)
	--Inactivate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1131)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.discon)
	e1:SetCost(s.discost)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--tohand&special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.cost)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1131)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.discon2)
	e3:SetCost(s.discost2)
	e3:SetTarget(s.distg2)
	e3:SetOperation(s.disop2)
	c:RegisterEffect(e3)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and Duel.IsChainDisablable(ev) and loc==LOCATION_GRAVE+LOCATION_REMOVED
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,s.sprfilter,1,REASON_SPSUMMON,true,c)
end
function s.sprfilter(c,tp)
	return c:IsLevel(1) and Duel.GetMZoneCount(tp,c)>0 and c:IsReleasable()
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectReleaseGroupEx(tp,s.sprfilter,1,1,REASON_SPSUMMON,true,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.Release(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function s.discon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ev<=1 then return false end
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
		and (Duel.IsChainDisablable(ev) or Duel.IsChainDisablable(ev-1))
end
function s.discost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x452,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x452,1,REASON_COST)
end
function s.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsChainDisablable(ev)
	local b2=Duel.IsChainDisablable(ev-1)
	if chk==0 then return b1 or b2 end
	local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,2),1},
		{b2,aux.Stringid(id,3),2})
	e:SetLabel(op)
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	elseif op==2 then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,te:GetHandler(),1,0,0)
		if te:GetHandler():IsDestructable() and te:GetHandler():IsRelateToEffect(te) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,te:GetHandler(),1,0,0)
		end
	end
end
function s.disop2(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToChain(ev) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	elseif op==2 then
		local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
		if Duel.NegateEffect(ev-1) and te:GetHandler():IsRelateToChain(ev-1) then
			Duel.Destroy(te:GetHandler(),REASON_EFFECT)
		end
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.thfilter(c)
	return c:IsSetCard(0x5454) and c:IsAbleToHand()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5454) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) 
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return (b1 or b2) and Duel.GetFlagEffect(tp,id+1)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) 
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local op=aux.SelectFromOptions(tp,{b1,1190},{b2,1152})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #sg>0 then
			if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 and sg:GetFirst():IsLocation(LOCATION_HAND) then
				Duel.ConfirmCards(1-tp,sg)
				if Duel.IsCanRemoveCounter(tp,1,0,0x452,1,REASON_EFFECT) 
					and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
					Duel.BreakEffect()
					if Duel.RemoveCounter(tp,1,0,0x452,1,REASON_EFFECT) then
						if Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
							and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
							local g=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
							if #g>0 then
								Duel.Summon(tp,g:GetFirst(),true,nil)
							end
						end
					end
				end
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.sumfilter(c)
	return c:IsSetCard(0x5454) and c:IsSummonable(true,nil)
end