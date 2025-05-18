--方舟骑士团-临光
local cm,m,o=GetID()
function cm.initial_effect(c)
	--summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(6616912,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(cm.ntcon)
	c:RegisterEffect(e0)
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(m,0))
	--e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	--e1:SetType(EFFECT_TYPE_IGNITION)
	--e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	--e1:SetCountLimit(1,m)
	--e1:SetTarget(cm.tg1)
	--e1:SetOperation(cm.op1)
	--c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(m)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)

	--pos
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.condition)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5)
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
end
function cm.opf1(c,e,tp)
	return c:IsSetCard(0x87af) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3):Filter(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)
	local sg=Duel.GetMatchingGroup(cm.opf1,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	Duel.ShuffleDeck(tp)
	if #g>0 and #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		sg=sg:Select(tp,1,ft>#g and #g or ft,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	if c:IsLocation(LOCATION_HAND) and c:IsRelateToEffect(e) then
		if Duel.IsPlayerAffectedByEffect(tp,29080291) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(29080291,2)) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)
			Duel.ShuffleHand(tp)
		end
	end
end
function cm.descheck(c,tp)
	return c:IsOnField() and c:IsControler(tp)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not c:IsPosition(POS_FACEUP_ATTACK) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return rp==1-tp and ex and tg~=nil and tc+tg:FilterCount(cm.descheck,nil,tp)-tg:GetCount()>0
end
function cm.check(c)
	return c:IsFaceup() and c:IsSetCard(0x87af)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPosition(POS_FACEUP_ATTACK) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
		local g=Duel.GetMatchingGroup(cm.check,tp,LOCATION_MZONE,0,nil)
		if g:GetCount()>0 then
			for tc in aux.Next(g) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetRange(LOCATION_MZONE)
				e1:SetLabelObject(re)
				e1:SetValue(cm.efilter)
				e1:SetReset(RESET_EVENT+RESET_CHAIN)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function cm.efilter(e,re)
	return re==e:GetLabelObject()
end