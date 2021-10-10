--能天使·KFC收藏-城市骑手
function c79029290.initial_effect(c)
	c:EnableReviveLimit()
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029051)
	c:RegisterEffect(e2)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_XYZ)
	e1:SetCondition(c79029290.sprcon)
	e1:SetOperation(c79029290.sprop)
	c:RegisterEffect(e1)		 
	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(c79029290.atcon)
	e3:SetCost(c79029290.atcost)
	e3:SetOperation(c79029290.atop)
	c:RegisterEffect(e3)
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetCountLimit(1,79029290)
	e3:SetCondition(c79029290.drcon)
	e3:SetTarget(c79029290.drtg)
	e3:SetOperation(c79029290.drop)
	c:RegisterEffect(e3)
end
function c79029290.sprfilter(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsFaceup() and (lv==9  or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsLocation(LOCATION_SZONE))) and (Duel.GetLocationCountFromEx(tp,tp,c)>0 or Duel.GetMZoneCount(tp,c)>0)
end
function c79029290.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c79029290.sprfilter,tp,LOCATION_ONFIELD,0,3,nil)
end
function c79029290.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c79029290.sprfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=g:Select(tp,3,3,nil)
	e:GetHandler():SetMaterial(g1)
	Duel.Overlay(e:GetHandler(),g1)
	Debug.Message("我帮你们预定了地狱黄金地段的房产，请放心！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029290,0))
end
function c79029290.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:IsChainAttackable(0)
end
function c79029290.ovfil1(c)
	return not c:IsType(TYPE_MONSTER) 
end
function c79029290.ovfil2(c)
	return not c:IsType(TYPE_SPELL) 
end
function c79029290.ovfil3(c)
	return not c:IsType(TYPE_TRAP) 
end
function c79029290.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup()
	if Duel.GetFlagEffect(tp,79029290)~=0 then
	g=g:Filter(c79029290.ovfil1,nil)
	end
	if Duel.GetFlagEffect(tp,09029290)~=0 then
	g=g:Filter(c79029290.ovfil2,nil)
	end
	if Duel.GetFlagEffect(tp,00029290)~=0 then
	g=g:Filter(c79029290.ovfil3,nil)
	end
	if chk==0 then return g:GetCount()~=0 end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	if tc:IsType(TYPE_MONSTER) then
	Duel.RegisterFlagEffect(tp,79029290,RESET_PHASE+PHASE_END,0,1)
	end
	if tc:IsType(TYPE_SPELL) then
	Duel.RegisterFlagEffect(tp,09029290,RESET_PHASE+PHASE_END,0,1)
	end
	if tc:IsType(TYPE_TRAP) then
	Duel.RegisterFlagEffect(tp,00029290,RESET_PHASE+PHASE_END,0,1)
	end
end
function c79029290.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(c:GetAttack()*2)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	Debug.Message("苹果派！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029290,1))
	local tc=e:GetLabelObject()
end
function c79029290.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,79029290)~=0
	and Duel.GetFlagEffect(tp,09029290)~=0
	and Duel.GetFlagEffect(tp,00029290)~=0
end
function c79029290.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c79029290.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end


















