--六花结誓
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(s.accon)
	e0:SetCost(s.cost)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.setcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(s.con)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_RELEASE)
		ge1:SetOperation(s.rlcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.rlcheck(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		Duel.RegisterFlagEffect(tc:GetOwner(),id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.accon(e)
	return e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function s.costfilter(c)
	return c:IsFaceupEx() and c:IsRace(RACE_PLANT) 
end
function s.setfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x141) and c:IsSSetable() and not c:IsCode(id) 
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,s.costfilter,1,REASON_COST,true,e:GetHandler(),tp) end
	local g=Duel.SelectReleaseGroupEx(tp,s.costfilter,1,1,REASON_COST,true,e:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end
function s.costfilter2(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceupEx()) and (c:IsRace(RACE_PLANT) or c:IsHasEffect(76869711,tp) and c:IsControler(1-tp))
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,s.costfilter2,1,REASON_COST,true,e:GetHandler(),tp) end
	local g=Duel.SelectReleaseGroupEx(tp,s.costfilter2,1,1,REASON_COST,true,e:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=nil
	if e:GetHandler():IsStatus(STATUS_SET_TURN) then
		b1=Duel.CheckReleaseGroupEx(tp,s.costfilter,2,REASON_COST,true,e:GetHandler(),tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	else
		b1=Duel.CheckReleaseGroupEx(tp,s.costfilter,1,REASON_COST,true,e:GetHandler(),tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	if chk==0 then return b1 end
	Duel.SetOperationInfo(0,CATEGORY_SSET,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local seg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
			local tc=seg:GetFirst()
			if tc then
				if Duel.SSet(tp,tc)>0 and tc:CheckActivateEffect(false,true,false)~=nil and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
				tc:CreateEffectRelation(e)
				if not te then return end
				local tg=te:GetTarget()
				if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
				Duel.ClearOperationInfo(0)
				if not te:GetHandler():IsRelateToChain() then return end
				e:SetLabelObject(te:GetLabelObject())
				local op=te:GetOperation()
				if op then op(e,tp,eg,ep,ev,re,r,rp) end
			end
		end
	end
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>1
end
function s.matfilter(c)
	return c:IsFaceupEx() and c:IsRace(RACE_PLANT) and (c:IsCanBeXyzMaterial(nil) or c:IsAbleToHand())
end
function s.exgfilter(c,mg,mc)
	return mg:CheckSubGroup(s.exgselect,2,2,c,mc)
end
function s.exgselect(g,exc,mc)
	return exc:IsSetCard(0x141) and exc:IsXyzSummonable(g,2,2)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.matfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(s.matfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,2,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local xyzg=Duel.GetMatchingGroup(s.exgfilter,tp,LOCATION_EXTRA,0,nil,sg,2,2)
	local sc=sg:GetFirst()
	if sc then
		if sc:IsAbleToHand() and (xyzg:GetCount()<1 or Duel.SelectOption(tp,1190,aux.Stringid(id,5))==0) then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		elseif xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local msg=sg:SelectSubGroup(tp,s.exgselect,false,2,2,xyz)
			Duel.XyzSummon(tp,xyz,msg,#msg,#msg)
		end
	end
end