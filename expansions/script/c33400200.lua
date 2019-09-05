--天使-嗫告篇帙
function c33400200.initial_effect(c)
	 c:SetUniqueOnField(1,0,33400200)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 --confirm 1-TP
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c33400200.target1)
	e2:SetOperation(c33400200.operation)
	c:RegisterEffect(e2)
	 --confirm TP
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400200,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e3:SetCountLimit(1)
	e3:SetTarget(c33400200.target2)
	e3:SetCondition(c33400200.condition)
	e3:SetOperation(c33400200.operation2)
	c:RegisterEffect(e3)
	 --future record
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33400200,3))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCategory(CATEGORY_ANNOUNCE+CATEGORY_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(c33400200.condition)
	e4:SetOperation(c33400200.operation3)
	c:RegisterEffect(e4)
end
function c33400200.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
end
function c33400200.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.SelectOption(tp,aux.Stringid(33400200,0),aux.Stringid(33400200,1))
	if op==0 then	 
		local g=Duel.GetFieldGroup(tp,0,LOCATION_SZONE+LOCATION_MZONE):Filter(Card.IsFacedown,nil)
		local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			g1:Merge(g)
			Duel.ConfirmCards(tp,g1)
			Duel.ShuffleHand(1-tp)
		if #g>0 then
		Duel.ConfirmCards(tp,g)
		end
	else 
		local cm=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
		if cm>6 then cm=6 end
		local g=Duel.GetDecktopGroup(1-tp,cm)
		  Duel.ConfirmCards(tp,g)
		  Duel.SortDecktop(tp,1-tp,cm)
	end 
end
function c33400200.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function c33400200.condition(e,tp,eg,ep,ev,re,r,rp)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	return tn~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
end
function c33400200.operation2(e,tp,eg,ep,ev,re,r,rp)
		local cm=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		if cm>6 then cm=6 end
		local g=Duel.GetDecktopGroup(tp,cm)
		  Duel.ConfirmCards(tp,g)
		  Duel.SortDecktop(tp,tp,cm)
end
function c33400200.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	 Duel.ConfirmDecktop(1-tp,1)
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	local token=Duel.CreateToken(tp,ac)
	local t1=bit.band(token:GetType(),0x7)
	local t2=bit.band(tc:GetType(),0x7)
	if t1==t2  then 
		if Duel.SelectYesNo(tp,aux.Stringid(33400200,4))  then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		 local tc0=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
		   local tc1=tc0:GetFirst()
			   Duel.NegateRelatedChain(tc1,RESET_TURN_SET)
			local e1=Effect.CreateEffect(tc1)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc1:RegisterEffect(e1)
			local e2=Effect.CreateEffect(tc1)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc1:RegisterEffect(e2)
			if tc1:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(tc1)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc1:RegisterEffect(e3)
			end
		end
	end
	if tc:IsCode(ac) then 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetTargetRange(LOCATION_ONFIELD,0)
			e1:SetTarget(c33400200.tgfilter)
			e1:SetValue(1)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)	 
	end
end
function c33400200.tgfilter(e,c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x341)
end