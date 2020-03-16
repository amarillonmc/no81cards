--D.A.L 星宫六喰
local m=33400636
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --xyz summon
	c:EnableReviveLimit()
	 aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,3,99,cm.ovfilter,aux.Stringid(m,0),cm.xyzop)
 --CANNOT ACTIVATE
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.aclimit)
	c:RegisterEffect(e1)  
 --cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
 --disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_REMOVED)
	c:RegisterEffect(e3)
 --Activate(summon)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(2,m)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(cm.discost)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.activate)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(2,m)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(cm.discost)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.activate)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCountLimit(2,m)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(cm.discost)
	e6:SetTarget(cm.target)
	e6:SetOperation(cm.activate)
	c:RegisterEffect(e6)
 --todeck
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,0))
	e7:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_REMOVED)
	e7:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e7:SetCountLimit(1,m+10000)
	e7:SetCondition(cm.tdcon1)
	e7:SetTarget(cm.tdtg)
	e7:SetOperation(cm.tdop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetCondition(cm.tdcon2)
	c:RegisterEffect(e8)
--Equip Okatana
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetOperation(cm.Eqop1)
	c:RegisterEffect(e9)
end
function cm.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and  c:IsSetCard(0x341) 
end
function cm.xyzcheck(g)
	return  g:IsExists(Card.IsSetCard,1,nil,0x9342)
end
function cm.cfilter(c)
	return c:IsSetCard(0x341)  and  c:IsType(TYPE_XYZ) and c:IsAbleToExtraAsCost() 
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x341) 
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,6,nil) end
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	 local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,6,6,nil)  
	 Duel.SendtoDeck(g,tp,2,REASON_COST)
end

function cm.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_REMOVED
end

function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return  ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end   
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function cm.filter(c)
	return  c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return eg:IsExists(cm.filter,1,nil) end
	local g=eg:Filter(cm.filter,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.efilter(c,e)
	return  c:IsRelateToEffect(e)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(cm.efilter,nil,e)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	 if  Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) then 
			 if  Duel.SelectYesNo(tp,aux.Stringid(m,2)) then			   
				 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,6,nil) 
				g2:AddCard(e:GetHandler())
				 Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
			 end
	end  
end

function cm.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33460651)==0 
end
function cm.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33460651)>0 
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil,tp) end   
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x341)  and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)  
local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE) 
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc2=g2:GetFirst()
	if Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)~=0 then	   
		if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
			if  Duel.SelectYesNo(tp,aux.Stringid(m,3)) then  
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp) 
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP) 
			end 
		end
	end
	if  Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) then 
		 if  Duel.SelectYesNo(tp,aux.Stringid(m,4)) then 
			Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAINING)
			e1:SetOperation(cm.actop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end  
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x9342) and ep==tp then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end

function cm.Eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		cm.TojiEquip(c,e,tp,eg,ep,ev,re,r,rp)
	end
end
function cm.TojiEquip(ec,e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,m+1)
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
			e4:SetValue(cm.efilter1)
			token:RegisterEffect(e4)
			--indes
			local e5=Effect.CreateEffect(ec)
			e5:SetType(EFFECT_TYPE_EQUIP)
			e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e5:SetValue(cm.valcon)
			e5:SetCountLimit(1)
			token:RegisterEffect(e5)
		   --DISABLE
			local e1=Effect.CreateEffect(ec)
			e1:SetDescription(aux.Stringid(m,5))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_EQUIP)
			e1:SetCode(EVENT_REMOVE)
			e1:SetRange(LOCATION_SZONE)
			e1:SetCondition(cm.matcon)
			e1:SetTarget(cm.mattg)
			e1:SetOperation(cm.matop)
			token:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EVENT_TO_DECK)
			token:RegisterEffect(e2)
	return true
	else Duel.SendtoGrave(token,REASON_RULE) return false
	end
end
function cm.efilter1(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.valcon(e,re,r,rp)
	return r==REASON_BATTLE
end
function cm.matcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m+1)<2
end
function cm.xyzfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x341)
end
function cm.matfilter2(c)
	return  c:IsCanOverlay()
end
function cm.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.xyzfilter2(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.xyzfilter2,tp,LOCATION_MZONE,0,1,nil)
	end   
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
 local gs=Duel.GetMatchingGroupCount(cm.matfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
   if not Duel.IsExistingMatchingCard(cm.xyzfilter2,tp,LOCATION_MZONE,0,1,nil) or gs==0 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tg=Duel.SelectMatchingCard(tp,cm.xyzfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=tg:GetFirst()
	if  not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.matfilter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)   
			Duel.Overlay(tc,g)
	end
	Duel.RegisterFlagEffect(tp,m+1,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)   
end