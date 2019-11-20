--D.A.L 本条二亚
function c33400220.initial_effect(c)
	 --xyz summon
	c:EnableReviveLimit()
	 aux.AddXyzProcedureLevelFree(c,c33400220.mfilter,c33400220.xyzcheck,2,99,c33400220.ovfilter,aux.Stringid(33400220,0),c33400220.xyzop)  
	  --spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1) 
	 --material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400220,4))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c33400220.macon)
	e2:SetTarget(c33400220.matg)
	e2:SetOperation(c33400220.maop)
	c:RegisterEffect(e2)
	 --Damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400220,1))
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,33400220)
	e3:SetCost(c33400220.dmcost)
	e3:SetOperation(c33400220.dmop)
	c:RegisterEffect(e3)
	   --confirm 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33400220,2))
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e4:SetCountLimit(1,33400220+10000)
	e4:SetTarget(c33400220.target2)
	e4:SetOperation(c33400220.operation2)
	c:RegisterEffect(e4)
	  --Equip Okatana
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(33400220,5))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetOperation(c33400220.Eqop1)
	c:RegisterEffect(e5)
end
function c33400220.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and  c:IsSetCard(0x341) and c:IsRankAbove(6)
end
function c33400220.xyzcheck(g)
	return  g:IsExists(Card.IsSetCard,1,nil,0x6342)
end
function c33400220.cfilter(c)
	return c:IsSetCard(0x341)  and  c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost() and c:IsRankAbove(6)
end
function c33400220.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x341) 
end
function c33400220.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400220.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	 local g1=Duel.GetMatchingGroup(c33400220.cfilter,tp,LOCATION_GRAVE,0,nil)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE) 
	local g=g1:SelectSubGroup(tp,c33400220.xyzcheck,false,2,99)	 
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c33400220.macon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c33400220.mafilter(c)
	return c:IsSetCard(0x341) and c:IsType(TYPE_XYZ)
end
function c33400220.matg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400220.mafilter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
end
function c33400220.maop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33400220.mafilter,tp,LOCATION_REMOVED,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:Select(tp,1,99,nil)
	 if sg and sg:GetCount()>0 and e:GetHandler():IsRelateToEffect(e) then
			Duel.Overlay(e:GetHandler(),sg)
		end
end
function c33400220.dmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function c33400220.dmop(e,tp,eg,ep,ev,re,r,rp)
	local tc2=e:GetHandler()  
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
	   Duel.Damage(1-tp,1000,REASON_EFFECT) 
		 if Duel.SelectYesNo(tp,aux.Stringid(33400220,3)) then 
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			 local g1=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil)
			 Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
			 local tc1=g1:GetFirst()
			   local e1=Effect.CreateEffect(tc2)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				e1:SetTarget(c33400220.distg2)
				e1:SetLabelObject(tc1)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				local e2=Effect.CreateEffect(tc2)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_CHAIN_SOLVING)
				e2:SetCondition(c33400220.discon2)
				e2:SetOperation(c33400220.disop2)
				e2:SetLabelObject(tc1)
				e2:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e2,tp)  
		 end	 
	end
	if tc:IsCode(ac) then  
			Duel.Damage(1-tp,1000,REASON_EFFECT) 
			local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
			local tc=g2:GetFirst()
			while tc do
				local e4=Effect.CreateEffect(e:GetHandler())
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_IMMUNE_EFFECT)
				e4:SetValue(c33400220.efilter)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e4:SetOwnerPlayer(tp)
				tc:RegisterEffect(e4)
				tc=g2:GetNext()
			end
	end
end
function c33400220.distg2(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c33400220.discon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c33400220.disop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c33400220.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--e4
function c33400220.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,LOCATION_DECK)>0 end
end
function c33400220.operation2(e,tp,eg,ep,ev,re,r,rp)
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
--e5
function c33400220.Eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		c33400220.TojiEquip(c,e,tp,eg,ep,ev,re,r,rp)
	end
end
function c33400220.TojiEquip(ec,e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,33400221)
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
			e4:SetValue(c33400220.efilter1)
			token:RegisterEffect(e4)
			--indes
			local e5=Effect.CreateEffect(ec)
			e5:SetType(EFFECT_TYPE_EQUIP)
			e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e5:SetValue(c33400220.valcon)
			e5:SetCountLimit(1)
			token:RegisterEffect(e5)
			--inm
			local e6=Effect.CreateEffect(token)
			e6:SetType(EFFECT_TYPE_QUICK_O)
			e6:SetCategory(CATEGORY_ANNOUNCE)
			e6:SetRange(LOCATION_SZONE)
			e6:SetCode(EVENT_FREE_CHAIN)
			e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
			e6:SetCountLimit(1)
			e6:SetOperation(c33400220.operation3)
			token:RegisterEffect(e6,true)
	return true
	else Duel.SendtoGrave(token,REASON_RULE) return false
	end
end
function c33400220.efilter1(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c33400220.valcon(e,re,r,rp)
	return r==REASON_BATTLE
end
function c33400220.operation3(e,tp,eg,ep,ev,re,r,rp)
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
			e1:SetTargetRange(LOCATION_ONFIELD,0)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP))
			e1:SetValue(c33400220.indct)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)   
	end
end
function c33400220.indct(e,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end