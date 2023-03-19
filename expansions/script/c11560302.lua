--次元开拓者 巴妮
function c11560302.initial_effect(c) 
	--redirect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11560302+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11560302.spcon)
	c:RegisterEffect(e1) 
	--lv and remove 
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,21560302)   
	e2:SetCost(c11560302.lrcost)
	e2:SetTarget(c11560302.lrtg) 
	e2:SetOperation(c11560302.lrop) 
	c:RegisterEffect(e2)
	--become material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c11560302.efcon)
	e3:SetOperation(c11560302.efop)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,31560302)
	e4:SetTarget(c11560302.rthtg)
	e4:SetOperation(c11560302.rthop)
	c:RegisterEffect(e4)
end
c11560302.SetCard_XdMcy=true 
function c11560302.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 
end 
function c11560302.lrckfil(c) 
	return c:IsAbleToDeckAsCost() and c.SetCard_XdMcy and c:IsLevelAbove(1) and c:IsType(TYPE_MONSTER) 
end 
function c11560302.lrcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11560302.lrckfil,tp,LOCATION_REMOVED,0,1,nil) end 
	local tc=Duel.SelectMatchingCard(tp,c11560302.lrckfil,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()  
	Duel.SendtoDeck(tc,nil,2,REASON_COST) 
	e:SetLabel(tc:GetLevel())
end 
function c11560302.lrtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_DECK)
end 
function c11560302.lrop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local lv=c:GetLevel() 
	local xlv=e:GetLabel()
	if c:IsRelateToEffect(e) then 
	-- 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_CHANGE_LEVEL)  
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(xlv) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1)  
	local x=math.abs(lv-xlv) 
	local g=Duel.GetDecktopGroup(tp,x)
	if x~=0 and g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==x then 
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end   
	end 
end 
function c11560302.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL and not e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY)
end
function c11560302.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,11560302)
	local rc=eg:GetFirst()
	while rc do
		if rc:GetFlagEffect(11560302)==0 then
			--attack all
			local e1=Effect.CreateEffect(rc)
			e1:SetDescription(aux.Stringid(11560302,0))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(c11560302.ctval)
			rc:RegisterEffect(e1)
			if not rc:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e2,true)
			end
			rc:RegisterFlagEffect(11560302,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		rc=eg:GetNext()
	end
end 
function c11560302.ctckfil1(c) 
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) 
end 
function c11560302.ctckfil2(c) 
	return c:IsFaceup() and c:IsType(TYPE_SPELL) 
end 
function c11560302.ctckfil3(c) 
	return c:IsFaceup() and c:IsType(TYPE_TRAP) 
end 
function c11560302.ctval(e,re,rp)  
	local c=e:GetHandler() 
	local tp=c:GetControler()
	local flag=0 
	if Duel.IsExistingMatchingCard(c11560302.ctckfil1,tp,LOCATION_REMOVED,0,1,nil) then 
	flag=bit.bor(flag,TYPE_MONSTER) 
	end 
	if Duel.IsExistingMatchingCard(c11560302.ctckfil2,tp,LOCATION_REMOVED,0,1,nil) then 
	flag=bit.bor(flag,TYPE_SPELL) 
	end 
	if Duel.IsExistingMatchingCard(c11560302.ctckfil3,tp,LOCATION_REMOVED,0,1,nil) then 
	flag=bit.bor(flag,TYPE_TRAP) 
	end  
	if flag==0 then return false 
	else return aux.tgoval(e,re,rp) and re:IsActiveType(flag) end 
end
function c11560302.rthfil(c)
	return c.SetCard_XdMcy and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c11560302.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11560302.rthfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11560302.rthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11560302.rthfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end



