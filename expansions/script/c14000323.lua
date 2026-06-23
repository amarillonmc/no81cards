--吞式者的伴兽
local m=14000323
local cm=_G["c"..m]
cm.named_with_Aotual=1
function cm.initial_effect(c)
	aux.AddCodeList(c,14000326)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK)
	e2:SetCost(cm.costchk)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC_G)
	e3:SetRange(LOCATION_DECK)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(cm.dacon)
	c:RegisterEffect(e3)
end
function cm.AOTU(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Aotual
end
function cm.filter(c,e,tp,m1,ft)
	if not cm.AOTU(c) or not (c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL))
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg1=m1:Filter(aux.TRUE,c,nil)
	local mg2=m1:Filter(Card.IsControler,c,tp)
	if ft>0 then
		return #mg1>0
	else
		return #mg2>0
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(function(c) return c:IsReleasable() and not cm.AOTU(c) end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg1,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetMatchingGroup(function(c) return c:IsReleasable() and not cm.AOTU(c) end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg1,ft)
	local tc=g:GetFirst()
	local mat=Group.CreateGroup()
	if tc then
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg1:Select(tp,1,1,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg1:FilterSelect(tp,Card.IsControler,1,1,tc,tp)
		end
		Duel.Release(mat,REASON_EFFECT)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
			local hg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,0,LOCATION_HAND,nil)
			if tc:IsCode(14000326) then
				b1=#hg>0
			else
				b1=false
			end
			if not tc:IsCode(14000326) then
				b2=mat:GetFirst():IsAbleToHand()
			else
				b2=false
			end
			if (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.BreakEffect()
				if b1 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local g=hg:RandomSelect(tp,1)
					Duel.SendtoGrave(g,REASON_EFFECT)
				end
				if b2 then
					Duel.HintSelection(mat)
					Duel.SendtoHand(mat,nil,REASON_EFFECT)
				end
			end
		end
	end
end
function cm.handfilter(c)
	return c:IsCode(14000326) and not c:IsPublic()
end
function cm.costchk(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.handfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.handfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function cm.dacon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.handfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end