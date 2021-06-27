--D.A.L 鸢一折纸 
function c33400411.initial_effect(c)
	  --xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c33400411.mfilter,c33400411.xyzcheck,3,99,c33400411.ovfilter,aux.Stringid(33400411,0),c33400411.xyzop)
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1) 
	 --Equip Okatana
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33400411,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetOperation(c33400411.Eqop1)
	c:RegisterEffect(e4)	
   --material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400411,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetTarget(c33400411.matg)
	e2:SetOperation(c33400411.maop)
	c:RegisterEffect(e2) 
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400411,3))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(2,33400411)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c33400411.discon)
	e3:SetCost(c33400411.discost)
	e3:SetTarget(c33400411.distg)
	e3:SetOperation(c33400411.disop)
	c:RegisterEffect(e3)
end
function c33400411.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and c:IsSetCard(0x341)  
end
function c33400411.xyzcheck(g)
	return g:IsExists(Card.IsSetCard,1,nil,0x5342)  
end
function c33400411.ovfilter(c)
	return c:IsFaceup() 
end
function c33400411.refilter1(c)
	return c:IsXyzType(TYPE_XYZ) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5342) 
end
function c33400411.refilter2(c)
	return c:IsXyzType(TYPE_XYZ) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x341)
end
function c33400411.check(g)
	return   g:IsExists(Card.IsSetCard,1,nil,0x5342) 
end
function c33400411.xyzop(e,tp,chk,c)
	local g1nm=Duel.GetMatchingGroupCount(c33400411.refilter1,tp,LOCATION_GRAVE,0,nil)
	local g2nm=Duel.GetMatchingGroupCount(c33400411.refilter2,tp,LOCATION_GRAVE,0,nil)
	local cnm=g2nm-g1nm
	if chk==0 then return cnm>=3 or (g1nm>=1 and g2nm>=3) end
	local g=Duel.GetMatchingGroup(c33400411.refilter2,tp,LOCATION_GRAVE,0,nil)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:SelectSubGroup(tp,c33400411.check,false,3,99)	 
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end

--e4
function c33400411.Eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		c33400411.TojiEquip(c,e,tp,eg,ep,ev,re,r,rp)
	end
end
function c33400411.TojiEquip(ec,e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,33400412)
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
			e4:SetValue(c33400411.efilter1)
			token:RegisterEffect(e4)
			--indes
			local e5=Effect.CreateEffect(ec)
			e5:SetType(EFFECT_TYPE_EQUIP)
			e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e5:SetValue(c33400411.valcon)
			e5:SetCountLimit(1)
			token:RegisterEffect(e5)
			 --inm
			local e3=Effect.CreateEffect(ec)
			e3:SetType(EFFECT_TYPE_QUICK_O)
			e3:SetCode(EVENT_CHAINING)
			e3:SetCategory(CATEGORY_EQUIP)
			e3:SetRange(LOCATION_SZONE)
			e3:SetCountLimit(1)
			e3:SetOperation(c33400411.op3)
			token:RegisterEffect(e3)
	return true
	else Duel.SendtoGrave(token,REASON_RULE) return false
	end
end
function c33400411.efilter1(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c33400411.valcon(e,re,r,rp)
	return r==REASON_BATTLE
end
function c33400411.op3(e,tp,eg,ep,ev,re,r,rp)   
			local e3_1=Effect.CreateEffect(e:GetHandler())
			e3_1:SetType(EFFECT_TYPE_SINGLE)
			e3_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3_1:SetRange(LOCATION_SZONE)
			e3_1:SetCode(EFFECT_IMMUNE_EFFECT)
			e3_1:SetValue(c33400411.efilter3_1)
			e3_1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
			e:GetHandler():RegisterEffect(e3_1,true)
			local tg=Duel.GetMatchingGroupCount(c33400411.filter,tp,LOCATION_GRAVE,0,nil,tp)
			if tg>0 then 
				if Duel.SelectYesNo(tp,aux.Stringid(33400411,5)) then 
				  local g=Duel.GetMatchingGroup(c33400411.filter,tp,LOCATION_GRAVE,0,nil,tp)
				  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				  local g1=g:Select(tp,1,1,nil)
				  local tc=g1:GetFirst()
				  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
				  local tc2=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_MZONE,0,1,1,nil,0x5342)
				  local tc1=tc2:GetFirst()
				  Duel.Equip(tp,tc,tc1)
				   if tc:IsSetCard(0x5343) then
					   local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_EQUIP_LIMIT)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1:SetValue(c33400411.eqlimit)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e1)   
				   end
				end
			end
end
function c33400411.efilter3_1(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c33400411.filter(c,tp)
	return ((c:IsSetCard(0x5343) and c:IsType(TYPE_EQUIP)) or c:IsSetCard(0x6343)) and c:CheckUniqueOnField(tp)
end
function c33400411.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() and c:IsSetCard(0x5342)
end

function c33400411.cfilter1(c)
	return c:IsSetCard(0x341) 
end
function c33400411.matg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400411.cfilter1,tp,LOCATION_GRAVE,0,1,nil) end   
end
function c33400411.maop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingTarget(c33400411.cfilter1,tp,LOCATION_GRAVE,0,1,nil) then return false end
	local c=e:GetHandler()  
	if  c:IsRelateToEffect(e)then   
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tc=Duel.SelectMatchingCard(tp,c33400411.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Overlay(c,tc)
		if Duel.SelectYesNo(tp,aux.Stringid(33400411,4)) then 
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		  local tc1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
		  Duel.Destroy(tc1,REASON_EFFECT)
		end
	end
end

function c33400411.disfilter1(c)
	return  c:IsReleasable() and  (c:IsSetCard(0x341) or c:IsSetCard(0x340) or c:IsSetCard(0x6343))
end
function c33400411.discon(e,tp,eg,ep,ev,re,r,rp)
	return  not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c33400411.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return  Duel.IsExistingMatchingCard(c33400411.disfilter1,tp,LOCATION_ONFIELD,0,1,nil) and ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end 
	local tg=Duel.SelectMatchingCard(tp,c33400411.disfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(tg,REASON_COST)  
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function c33400411.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c33400411.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end