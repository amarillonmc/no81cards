--湮潮使·哕
local s,id,o=GetID()
function s.initial_effect(c)
	if not CATEGORY_SSET then CATEGORY_SSET=0 end
	c:EnableReviveLimit()
	--material
	aux.AddFusionProcFunRep2(c,s.mfilter,2,127,true)
	--
	c:EnableCounterPermit(0x452)
	aux.AddCodeList(c,0x452)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetCondition(s.sprcon)
	e0:SetTarget(s.sprtg)
	e0:SetOperation(s.sprop)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.con1)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1193)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.con3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
end
function s.mfilter(c,fc,sub,mg,sg)
	return aux.IsCodeListed(c,0x452)
end
function s.sprfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,0x452) 
end
function s.fselect1(g,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0 and g:IsExists(Card.IsAbleToGraveAsCost,2,nil)
end
function s.fselect2(g,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0 and g:IsExists(Card.IsAbleToRemoveAsCost,2,nil)
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(s.fselect1,2,2,tp,c) or g:CheckSubGroup(s.fselect2,2,2,tp,c)
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_ONFIELD,0,nil)
	b1=g:CheckSubGroup(s.fselect1,2,2,tp,c)
	b2=g:CheckSubGroup(s.fselect2,2,2,tp,c)
	local op=aux.SelectFromOptions(tp,{b1,1191},{b2,1102})
	e:SetLabel(op)
	local check=false
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:SelectSubGroup(tp,s.fselect1,true,2,2,tp,c)
		if sg then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			check=true
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:SelectSubGroup(tp,s.fselect2,true,2,2,tp,c)
		if sg then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			check=true
		end
	end
	if check then
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	local op=e:GetLabel()
	c:SetMaterial(g)
	if op==1 then
		Duel.SendtoGrave(g,REASON_SPSUMMON)
	else
		Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	end
	g:DeleteGroup()
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x452,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x452,1,REASON_COST)
end
function s.efilter(c)
	return c:IsSetCard(0x5454) and c:IsFaceup()
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id+1)==0 and Duel.IsExistingMatchingCard(s.efilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,id+2)==0 then return end
	local g=Duel.GetMatchingGroup(s.efilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(s.atkval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE+RESET_DISABLE)
		tc:RegisterEffect(e1)
	end
	Duel.RegisterFlagEffect(id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.atkval(e,c)
	return c:GetAttack()*2
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x452,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x452,1,REASON_COST)
end
function s.tdfilter(c)
	return c:IsSetCard(0x5454) and c:IsAbleToDeck() and c:IsFaceupEx()
end
function s.setfilter(c)
	return c:IsSetCard(0x5454) and c:IsSSetable()
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 
		and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,5,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
			if Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local sg=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
				if #sg>0 then
					Duel.SSet(tp,sg:GetFirst())
				end
			end
		end
	end
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsBattlePhase() and Duel.GetTurnPlayer()==tp
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5454)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e1:SetValue(ct)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(s.efilter,tp,LOCATION_ONFIELD,0,nil)
	if c:IsRelateToEffect(e) and c:IsFaceup() and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		for tc in aux.Next(g) do
			tc:AddCounter(0x452,1)
		end
	end
end