--邪魂 魔岩巨兵 达路斯克
function c30000605.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c30000605.sprcon)
	e1:SetOperation(c30000605.sprop)
	c:RegisterEffect(e1)  
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30000605,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c30000605.atkcost)
	e2:SetOperation(c30000605.atkop)
	c:RegisterEffect(e2)
	--e gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(30000605,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c30000605.con)
	e3:SetCost(c30000605.cost)
	e3:SetTarget(c30000605.sptg)
	e3:SetOperation(c30000605.spop)
	c:RegisterEffect(e3) 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(30000605,3))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCountLimit(1,30000605)
	e4:SetTarget(c30000605.rtg)
	e4:SetOperation(c30000605.rop)
	c:RegisterEffect(e4)
end
function c30000605.spcfil(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToRemoveAsCost()
end
function c30000605.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,c)
	return  rg:GetCount()>4 and rg:IsExists(c30000605.spcfil,1,nil,tp)
end
function c30000605.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Group.CreateGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,5,5,c)
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		local g1=Duel.SelectMatchingCard(tp,c30000605.spcfil,tp,LOCATION_MZONE,0,1,1,nil,tp)
		g1:AddCard(c)
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,4,4,g1)
		g1:RemoveCard(c)
		g1:Merge(g2)
		sg:Merge(g1)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c30000605.atkcfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function c30000605.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30000605.atkcfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c30000605.atkcfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:KeepAlive()
	e:SetLabelObject(g)
end 
function c30000605.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=e:GetLabelObject()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if sg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_IMMUNE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetLabel(TYPE_MONSTER)
			e2:SetValue(c30000605.efilter)
			e2:SetOwnerPlayer(tp)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e2,true)
		end
		if sg:IsExists(Card.IsType,1,nil,TYPE_SPELL) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetLabel(TYPE_SPELL)
			e3:SetValue(c30000605.efilter)
			e3:SetOwnerPlayer(tp)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e3,true)
		end
		if sg:IsExists(Card.IsType,1,nil,TYPE_TRAP) then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e4:SetRange(LOCATION_MZONE)
			e4:SetLabel(TYPE_TRAP)
			e4:SetValue(c30000605.efilter)
			e4:SetOwnerPlayer(tp)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e4,true)
		end
	end
end
function c30000605.efilter(e,re)
	local tpe=e:GetLabel()
	return re:IsActiveType(tpe) and re:GetHandler()~=e:GetHandler()
end
function c30000605.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return  ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c30000605.filter(c,e)
	if not ((c:GetReasonEffect()~=nil and c:GetReasonEffect():GetHandler()==e:GetHandler()) or c:GetReasonCard()==e:GetHandler()) then return false end
	return c:IsAbleToGraveAsCost()
end
function c30000605.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c30000605.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,5,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c30000605.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,5,5,nil,e)
	Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
end
function c30000605.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end  
end
function c30000605.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		--destroy
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_BATTLE_DESTROYING)
		e2:SetCost(c30000605.descost)
		e2:SetCondition(c30000605.descon)
		e2:SetOperation(c30000605.desop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e2)
	end
end
function c30000605.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c30000605.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30000605.atkcfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c30000605.atkcfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c30000605.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc:IsType(TYPE_MONSTER) and c:IsStatus(STATUS_OPPO_BATTLE)
end
function c30000605.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(c:GetAttackedCount())
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e2)
end
function c30000605.rtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,tp,LOCATION_REMOVED)
end
function c30000605.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_RETURN+REASON_EFFECT)
	end
end