--吸血鬼巫女
local s,id,o=GetID()
function s.initial_effect(c)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetHintTiming(TIMING_MAIN_END,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.sumcon)
	e2:SetCost(s.sumcost)
	e2:SetTarget(s.sumtg)
	e2:SetOperation(s.sumop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,5))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(s.reccon)
	e3:SetTarget(s.rectg)
	e3:SetOperation(s.recop)
	c:RegisterEffect(e3)
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function s.sumfilter(c,ec)
	if not c:IsSetCard(0x8e) then return false end
	--no tribute
	local e1=Effect.CreateEffect(ec)
	e1:SetDescription(aux.Stringid(id,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.ttcon)
	e1:SetOperation(s.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local res=c:IsSummonable(true,nil)
	e1:Reset()
	return res
end
function s.ttfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_ZOMBIE)
end
function s.ttcon(e,c,minc)
	if c==nil then return true end
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft==0 and mi<2 then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(s.ttfilter,tp,0,LOCATION_MZONE,nil)
	local ct=mg:GetCount()
	return ma>0 and ct>0 and ((ct>=mi and (ft>0 or Duel.CheckTribute(c,1))) or (ct<mi and Duel.CheckTribute(c,mi-ct)))
end
function s.ttop(e,tp,eg,ep,ev,re,r,rp,c,minc)
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	local tp=c:GetControler()
	local res=false
	local sg=Group.CreateGroup()
	while mi>0 do
		local mg1=Duel.GetMatchingGroup(s.ttfilter,tp,0,LOCATION_MZONE,nil)
		local mg2=Group.__sub(Duel.GetTributeGroup(c),sg)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 and not sg:IsExists(Card.IsControler,1,nil,tp) then mg2=mg2:Filter(Card.IsControler,nil,tp) end
		local mg=Group.__add(mg1,mg2)
		if res then Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1)) else
			mg=mg1:Clone()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		end
		local mc=mg:Select(tp,1,1,nil):GetFirst()
		local res1=s.ttfilter(mc) and (mi>1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
		--local res2=res and Group.GetCount(Group.__sub(mg,mc))>=mi-1
		res=true
		if res1 
			--and (not res2 or Duel.SelectYesNo(tp,aux.Stringid(id,3))) 
			then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetValue(RACE_ZOMBIE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			mc:RegisterEffect(e1)
			Duel.HintSelection(Group.FromCards(mc))
		else
			sg:AddCard(mc)
		end
		mi=mi-1
	end
	if #sg>0 then
		c:SetMaterial(sg)
		Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
	end
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND,0,1,1,nil,c):GetFirst()
	if tc then
		--no tribute
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,4))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SUMMON_PROC)
		e1:SetRange(LOCATION_HAND)
		e1:SetCondition(s.ttcon)
		e1:SetOperation(s.ttop)
		e1:SetValue(SUMMON_TYPE_ADVANCE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		--reset when negated
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SUMMON_NEGATED)
		e2:SetOperation(s.rstop)
		e2:SetLabelObject(e1)
		e2:SetReset(RESET_PHASE+PHASE_MAIN1)
		Duel.RegisterEffect(e2,tp)
		Duel.Summon(tp,tc,true,nil)
	end
end
function s.rstop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if e1 then e1:Reset() end
	e:Reset()
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsSetCard(0x8e)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
