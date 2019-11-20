--修女 时崎狂三
function c33400035.initial_effect(c)
	c:EnableCounterPermit(0x34f)
	 --xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c33400035.mfilter,c33400035.xyzcheck,3,99,c33400035.ovfilter,aux.Stringid(33400035,7),c33400035.xyzop)  
	--spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.xyzlimit)
	c:RegisterEffect(e0)  
	 --negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400035,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TODECK+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,33400035)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c33400035.necost)
	e1:SetCondition(c33400035.necon)
	e1:SetOperation(c33400035.neop)
	c:RegisterEffect(e1)
	 --material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400035,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,33400035+10000)
	e2:SetTarget(c33400035.matg)
	e2:SetOperation(c33400035.maop)
	c:RegisterEffect(e2)
	   --confirm 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400035,2))
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e3:SetCountLimit(1,33400035+20000)
	e3:SetTarget(c33400035.target2)
	e3:SetOperation(c33400035.operation2)
	c:RegisterEffect(e3)
	  --Equip Okatana
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33400035,5))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetOperation(c33400035.Eqop1)
	c:RegisterEffect(e4)
end
function c33400035.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and c:IsType(TYPE_MONSTER)
end
function c33400035.xyzcheck(g)
	return g:IsExists(Card.IsSetCard,1,nil,0x3341) and g:IsExists(Card.IsSetCard,1,nil,0x7342)
end
function c33400035.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x341) 
end
function c33400035.refilter1(c)
	return c:IsXyzType(TYPE_XYZ) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3341) 
end
function c33400035.refilter2(c)
	return c:IsXyzType(TYPE_XYZ) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6342) 
end
function c33400035.refilter3(c)
	return c:IsXyzType(TYPE_XYZ) and c:IsType(TYPE_MONSTER) 
end
function c33400035.check(g)
	return   g:IsExists(Card.IsSetCard,1,nil,0x3341) and g:IsExists(Card.IsSetCard,1,nil,0x6342)
end
function c33400035.xyzop(e,tp,chk,c)
	local g1nm=Duel.GetMatchingGroupCount(c33400035.refilter1,tp,LOCATION_GRAVE,0,nil)
	local g2nm=Duel.GetMatchingGroupCount(c33400035.refilter2,tp,LOCATION_GRAVE,0,nil)
	local g3nm=Duel.GetMatchingGroupCount(c33400035.refilter3,tp,LOCATION_GRAVE,0,nil)
	local cnm=g1nm+g2nm
	local cnm2=g3nm-cnm
	if chk==0 then return cnm>=3 or (g1nm==1 and g2nm==1 and  cnm2>=1) end
	local g=Duel.GetMatchingGroup(c33400035.refilter3,tp,LOCATION_GRAVE,0,nil)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:SelectSubGroup(tp,c33400035.check,false,3,99)	 
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end

function c33400035.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34f,2,REASON_COST) and ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x34f,2,REASON_COST)
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function c33400035.necon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c33400035.neop(e,tp,eg,ep,ev,re,r,rp)
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
		 Duel.Damage(1-tp,600,REASON_EFFECT)  
		 if Duel.SelectYesNo(tp,aux.Stringid(33400035,4))  then
			if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
				Duel.Destroy(eg,REASON_EFFECT)
			end 
		end
	end
	if tc:IsCode(ac) then 
		 Duel.Damage(1-tp,600,REASON_EFFECT)  
		 if Duel.SelectYesNo(tp,aux.Stringid(33400035,5))  then
			  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400035,6))
			  local g1=Duel.SelectTarget(tp,c33400035.cfilter2,tp,LOCATION_MZONE,0,1,1,nil)
			  local tc2=g1:GetFirst()
			  local e1=Effect.CreateEffect(tc2)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e1:SetValue(tc2:GetBaseAttack()*2)
				tc2:RegisterEffect(e1)
			  local e3=Effect.CreateEffect(tc2)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_ATTACK_ALL)
				e3:SetValue(1)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc2:RegisterEffect(e3)
		end
	end
end
function c33400035.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x341) and c:IsType(TYPE_MONSTER)
end
function c33400035.cfilter1(c)
	return c:IsSetCard(0x341) 
end
function c33400035.matg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c33400035.cfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c33400035.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c33400035.maop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e)  and c:IsRelateToEffect(e)then	   
			Duel.Overlay(c,tc)
			c:AddCounter(0x34f,2)
	end
end
function c33400035.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,LOCATION_DECK)>0 end
end
function c33400035.operation2(e,tp,eg,ep,ev,re,r,rp)
		local cm1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		local cm2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
		if cm1>5 then cm1=5 end
		if cm2>5 then cm2=5 end
		local g=Duel.GetDecktopGroup(tp,cm1)
		  Duel.ConfirmCards(tp,g)
		  Duel.SortDecktop(tp,tp,cm1)
		local g=Duel.GetDecktopGroup(1-tp,cm2)
		  Duel.ConfirmCards(tp,g)
		  Duel.SortDecktop(tp,1-tp,cm2)
end
--e4
function c33400035.Eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		c33400035.TojiEquip(c,e,tp,eg,ep,ev,re,r,rp)
	end
end
function c33400035.TojiEquip(ec,e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,33400036)
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
			e4:SetValue(c33400035.efilter1)
			token:RegisterEffect(e4)
			--indes
			local e5=Effect.CreateEffect(ec)
			e5:SetType(EFFECT_TYPE_EQUIP)
			e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e5:SetValue(c33400035.valcon)
			e5:SetCountLimit(1)
			token:RegisterEffect(e5)
			--inm
			local e6=Effect.CreateEffect(token)
			e6:SetType(EFFECT_TYPE_QUICK_O)
			e6:SetRange(LOCATION_SZONE)
			e6:SetCode(EVENT_FREE_CHAIN)
			e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
			e6:SetCountLimit(1)
			e6:SetCost(c33400035.cost3)
			e6:SetOperation(c33400035.operation3)
			token:RegisterEffect(e6,true)
	return true
	else Duel.SendtoGrave(token,REASON_RULE) return false
	end
end
function c33400035.efilter1(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c33400035.valcon(e,re,r,rp)
	return r==REASON_BATTLE
end
function c33400035.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400035.filter,tp,LOCATION_ONFIELD,0,1,1,nil) end
 local g1=Duel.SelectMatchingCard(tp,c33400035.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
			local tc=g1:GetFirst()
			tc:AddCounter(0x34f,4)
end
function c33400035.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x34f,4)
end
function c33400035.operation3(e,tp,eg,ep,ev,re,r,rp)   
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)  
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetTargetRange(LOCATION_ONFIELD,0)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP))
			e1:SetValue(c33400035.indct)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)   
end
function c33400035.indct(e,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end