--星间书构筑司 时杰
local s,id,o=GetID()
function s.initial_effect(c)
	--Xyz Procedure
	aux.AddXyzProcedure(c,nil,1,2)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Return to Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(s.tdcost)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	--SS Library
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+o*2)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.libtg)
	e3:SetOperation(s.libop)
	c:RegisterEffect(e3)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x3226) and c:GetType()==TYPE_SPELL
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x3226,0x11,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) and c:IsFaceupEx()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		tc:AddMonsterAttribute(TYPE_NORMAL+TYPE_SPELL)
		if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 and Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=g:Select(tp,1,1,nil)
				Duel.XyzSummon(tp,tg:GetFirst(),nil)
			end
		end
	end
end
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local tc=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(tc)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,5,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
	local tc=e:GetLabelObject()
	if tc and tc:GetType()==TYPE_SPELL and tc:IsSetCard(0x3226) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			local te=tc:CheckActivateEffect(false,true,false)
			if not te then return end
			local tpe=tc:GetType()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			Duel.ClearTargetCard()
			if tg then
				if tc:IsSetCard(0x3226) then
					tg(e,tp,eg,ep,ev,re,r,rp,1)
				else
					tg(te,tp,eg,ep,ev,re,r,rp,1)
				end
			end
			Duel.BreakEffect()
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if not g then g=Group.CreateGroup() end
			for etc in aux.Next(g) do
				etc:CreateEffectRelation(te)
			end
			if op then
				if tc:IsSetCard(0x3226) then
					op(e,tp,eg,ep,ev,re,r,rp)
				else
					op(te,tp,eg,ep,ev,re,r,rp)
				end
			end
			for etc in aux.Next(g) do
				etc:ReleaseEffectRelation(te)
			end
		end
	end
end
function s.libfilter(c,e,tp)
	return c:IsCode(11613006) and Duel.IsPlayerCanSpecialSummonMonster(tp,3226002,0x3226,0x21,4000,4000,1,RACE_MACHINE,ATTRIBUTE_LIGHT)
end
function s.libtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.libfilter),tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_ONFIELD)
end
function s.libop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.libfilter),tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetValue(4000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_SET_BASE_DEFENSE)
		tc:RegisterEffect(e3,true)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(RACE_MACHINE)
		tc:RegisterEffect(e4,true)
		tc:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPELL)
		if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 then
			--Atk/Def Up
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(id,1))
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetRange(LOCATION_MZONE)
			e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(s.val)
			c:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e3)
		end
	end
end
function s.atkfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsFaceupEx()
end
function s.val(e,c)
	local tp=e:GetHandlerPlayer()
	local ct=Duel.GetMatchingGroupCount(s.atkfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	local og=Duel.GetOverlayGroup(tp,1,1)
	local oct=og:FilterCount(Card.IsType,nil,TYPE_SPELL)
	local v=(ct+oct)*100
	if c:IsControler(tp) then return v else return -v end
end