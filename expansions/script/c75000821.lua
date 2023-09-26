--冰龙神谕
function c75000821.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75000821,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,75000821)
	e1:SetTarget(c75000821.target)
	e1:SetOperation(c75000821.activate)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75000821,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,75000822)
	e2:SetTarget(c75000821.tg)
	e2:SetOperation(c75000821.op)
	c:RegisterEffect(e2)	
end
function c75000821.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsSetCard(0x755) and c:IsLevel(4)
end
function c75000821.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c75000821.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c75000821.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c75000821.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c75000821.filter(c)
	return c:IsSetCard(0x755) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c75000821.synfilter(c)
	return c:IsSynchroSummonable(nil) and c:IsSetCard(0x755)
end 
function c75000821.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		if Duel.IsExistingMatchingCard(c75000821.synfilter,tp,LOCATION_EXTRA,0,1,nil,nil) and Duel.IsExistingMatchingCard(c75000821.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75000821,1)) then   
			local sg=Duel.GetMatchingGroup(c75000821.synfilter,tp,LOCATION_EXTRA,0,nil,nil)
			if sg:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local pg=sg:Select(tp,1,1,nil)
				local tc=pg:GetFirst()
				if Duel.SynchroSummon(tp,pg:GetFirst(),nil)~=0 then
					local fid=c:GetFieldID()
					c:RegisterFlagEffect(75000821,RESET_EVENT+RESETS_STANDARD,0,1,fid)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetCountLimit(1)
					e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
					e1:SetLabel(fid)
					e1:SetLabelObject(c)
					e1:SetCondition(c75000821.thcon1)
					e1:SetOperation(c75000821.thop1)
					Duel.RegisterEffect(e1,tp)
				end
			end
		end
	end
end
function c75000821.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(75000821)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c75000821.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
--
function c75000821.tdfilter(c)
	return c:IsSetCard(0x755) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c75000821.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c75000821.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75000821.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c75000821.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c75000821.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Group.CreateGroup()
	g:AddCard(tc)
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		g:AddCard(c)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end