--辣鸡鲶包
function c10173034.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,aux.TRUE,c10173034.xyzcheck,2,99)   
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c10173034.atkval)
	c:RegisterEffect(e2)
	--Xyz Material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10173034,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10173034.xmcon)
	e3:SetTarget(c10173034.xmtg)
	e3:SetOperation(c10173034.xmop)
	c:RegisterEffect(e3)
	--battle
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLED)
	e4:SetOperation(c10173034.baop)
	c:RegisterEffect(e4)
end
function c10173034.xyzcheck(g)
	return g:GetClassCount(Card.GetOriginalLevel)==1 and g:IsExists(Card.IsLevelAbove,1,nil,1)
end
function c10173034.xmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc~=nil and bc:IsAttackAbove(c:GetAttack())
end
function c10173034.xmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and e:GetHandler():GetFlagEffect(10173034)==0
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,TYPE_MONSTER) end
	e:GetHandler():RegisterFlagEffect(10173034,RESET_CHAIN,0,1)
end
function c10173034.xmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsType(TYPE_XYZ) then return end
	local bc,count,g,sg=c:GetBattleTarget(),4,Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,TYPE_MONSTER)
	while count>0 and g:GetCount()>0 do
		if count<4 then
		   if not bc:IsRelateToBattle() or c:IsAttackAbove(bc:GetAttack()) or not Duel.SelectYesNo(tp,aux.Stringid(10173034,1)) then break 
		   end
		   Duel.BreakEffect()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		sg=g:Select(tp,1,1,nil)
		g:Sub(sg)
		if sg:GetFirst():IsImmuneToEffect(e) then break end
		Duel.Overlay(c,sg)
		count=count-1
		g:Sub(sg)
	end
end
function c10173034.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c10173034.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=c:GetBattleTarget()
	if d and c:IsFaceup() and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and d:IsStatus(STATUS_BATTLE_DESTROYED) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_SEND_REPLACE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetTarget(c10173034.reptg)
		e1:SetOperation(c10173034.repop)
		e1:SetLabelObject(c)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		d:RegisterEffect(e1)
	end
end
function c10173034.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_BATTLE) and not c:IsImmuneToEffect(e) end
	return true
end
function c10173034.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
		 if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		 end
	Duel.Overlay(e:GetLabelObject(),Group.FromCards(c))
end