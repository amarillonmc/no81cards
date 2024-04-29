local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK)
	e2:SetCost(s.cost)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_DECK)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetLabelObject(e2)
	e3:SetTarget(s.actarget)
	e3:SetOperation(s.costop)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(3)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.costfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsLevel(1) and c:IsType(TYPE_TUNER) and c:IsAbleToDeckAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function s.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_FZONE,POS_FACEUP,false)
	e:GetHandler():CreateEffectRelation(te)
	local c=e:GetHandler()
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(s.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function s.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
function s.filter(c,e,ct)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e) and c:GetSequence()+1<ct
end
function s.GetSequenceMinus(c,seq)
	return math.abs(c:GetSequence()-seq)
end
function s.fselect(g,og)
	if #g==1 then return true end
	local seq=g:GetFirst():GetSequence()
	local g1=og:Filter(function(c,seq)return c:GetSequence()>seq end,nil,seq)
	local g2=og:Filter(function(c,seq)return c:GetSequence()<seq end,nil,seq)
	local seq1,seq2=114514,0
	if #g1>0 then _,seq1=g1:GetMinGroup(Card.GetSequence) end
	if #g2>0 then _,seq2=g2:GetMaxGroup(Card.GetSequence) end
	return not g:IsExists(function(c,seq1,seq2)return c:GetSequence()>seq1 or c:GetSequence()<seq2 end,1,nil,seq1,seq2)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local cg=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil,e,#cg)
	if chk==0 then return #g>0 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local sg=g:SelectSubGroup(tp,s.fselect,false,1,#g,Group.__sub(cg,g))
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	local res1,res2=true,true
	for i=1,2 do
		local b1=res1 and tg and not tg:IsContains(Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1))
		local b2=res2 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,2)},{b2,aux.Stringid(id,3)})
		if op==1 then
			local sg=tg:Clone()
			while #sg>0 do
				local tc=sg:GetMinGroup(Card.GetSequence):GetFirst()
				Duel.MoveSequence(tc,0)
				sg:RemoveCard(tc)
			end
			res1=false
		elseif op==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
			Duel.SendtoGrave(g,REASON_EFFECT)
			res2=false
		end
	end
end
