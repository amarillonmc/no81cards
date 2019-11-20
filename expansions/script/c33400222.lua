--D.A.L-本条二亚-ALTER
function c33400222.initial_effect(c)
		c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	  --check card
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1)
	e1:SetCost(c33400222.ckcost)
	e1:SetTarget(c33400222.cktg)
	e1:SetOperation(c33400222.ckop)
	c:RegisterEffect(e1)
	 --Equip Okatana
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400222,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetOperation(c33400222.Eqop1)
	c:RegisterEffect(e2)
	--TOKEN
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(2)
	e3:SetTarget(c33400222.tktg)
	e3:SetOperation(c33400222.tkop)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33400222,4))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1,33400222)
	e4:SetCost(c33400222.cost)
	e4:SetOperation(c33400222.activate)
	c:RegisterEffect(e4)
end
function c33400222.ckcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c33400222.cktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,LOCATION_DECK)>0  end
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if chk==0 then return b1 or b2 end
	local op
	if b1 and b2 then 
			 op=Duel.SelectOption(tp,aux.Stringid(33400222,0),aux.Stringid(33400222,1))
			 Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())   
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(33400222,0))
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())   
	else
		op=Duel.SelectOption(tp,aux.Stringid(33400222,1))
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())   
	end
	e:SetLabel(op)
end
function c33400222.ckop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	cm1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	cm2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if cm1>4 then cm1=4 end
	if cm2>4 then cm2=4 end
	if op==0 then
		local g=Duel.GetDecktopGroup(tp,cm1)
		Duel.ConfirmCards(tp,g)  
		Duel.SortDecktop(tp,tp,cm1)   
	else 
		  local g=Duel.GetDecktopGroup(1-tp,cm2)
		  Duel.ConfirmCards(tp,g)
		  Duel.SortDecktop(tp,1-tp,cm2) 
	end
end
function c33400222.Eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		c33400222.TojiEquip(c,e,tp,eg,ep,ev,re,r,rp)
	end
end
function c33400222.TojiEquip(ec,e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,33400223)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	token:CancelToGrave()
	local e1_1=Effect.CreateEffect(token)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_CHANGE_TYPE)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
	e1_1:SetReset(RESET_EVENT+0x1fc0000)
	token:RegisterEffect(e1_1,true)
	local e1_2=Effect.CreateEffect(token)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetCode(EFFECT_EQUIP_LIMIT)
	e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_2:SetValue(1)
	token:RegisterEffect(e1_2,true)
	token:CancelToGrave()   
	if Duel.Equip(tp,token,ec,false) then 
			--immune
			local e4=Effect.CreateEffect(ec)
			e4:SetType(EFFECT_TYPE_EQUIP)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(c33400222.efilter1)
			token:RegisterEffect(e4)
			--indes
			local e5=Effect.CreateEffect(ec)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e5:SetRange(LOCATION_SZONE)
			e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e5:SetValue(c33400222.valcon)
			e5:SetCountLimit(1)
			token:RegisterEffect(e5)
			--inm
			local e6=Effect.CreateEffect(token)
			e6:SetType(EFFECT_TYPE_QUICK_O)
			e6:SetCategory(CATEGORY_ANNOUNCE)
			e6:SetRange(LOCATION_SZONE)
			e6:SetCode(EVENT_FREE_CHAIN)
			e6:SetCountLimit(1)
			e6:SetOperation(c33400222.operation3)
			token:RegisterEffect(e6,true)
		   
	return true
	else Duel.SendtoGrave(token,REASON_RULE) return false
	end
end
function c33400222.efilter1(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c33400222.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c33400222.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	 Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsCode(ac) then 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)  
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TOKEN))
			e1:SetValue(c33400222.indct)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)   
	end
end
function c33400222.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end
function c33400222.refilter(c)
	return c:IsSetCard(0x6342)  and c:IsReleasable()
end
function c33400222.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400222.refilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c33400222.refilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c33400222.filter(c,e,tp)
	return c:IsSetCard(0x341) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400222.activate(e,tp,eg,ep,ev,re,r,rp)
   if not Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) then return end 
   local tc=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	 if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	 end
	Duel.Destroy(tc,REASON_EFFECT)
end

function c33400222.filter(c,e,tp)
	return  c:GetSummonPlayer()==1-tp 
end
function c33400222.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:IsExists(c33400222.filter,1,nil,nil,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33400224,0x341+0x6342,0x4011,1000,1000,4,RACE_SPELLCASTER,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c33400222.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,33400224,0x6342,0x4011,1000,1000,4,RACE_SPELLCASTER,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,33400224)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end

function c33400222.cfilter2(c)
	return c:IsSetCard(0x6342)
end
function c33400222.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c33400222.cfilter2,1,nil) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c33400222.cfilter2,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c33400222.activate(e,tp,eg,ep,ev,re,r,rp)
	 if  not  Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)  then return end
	 local g1=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	  local c=e:GetHandler()
		 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400222,5))
		 local tc1=g1:Select(tp,1,1,nil)   
		 local tc=tc1:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end 
	Duel.BreakEffect()
	Duel.Destroy(tc,REASON_EFFECT)   
end