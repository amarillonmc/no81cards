-- 键★高潮 绘空事 / K.E.Y Climax - Fabbricazione
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(s.condition1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	--Activate(effect)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(s.condition2)
	e4:SetCost(s.cost)
	e4:SetTarget(s.target2)
	e4:SetOperation(s.activate2)
	c:RegisterEffect(e4)
	--lp
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(s.lptg)
	e5:SetOperation(s.lpop)
	c:RegisterEffect(e5)
end
s.wind_wb_key_monsters = true

function s.lvfilter(c)
	return c:IsFaceup() and (c:IsLevelAbove(1) or c:IsRankAbove(1))
end
function s.cfilter(c,tc)
	if not c:IsLevelAbove(1) and not c:IsType(TYPE_XYZ) then return false end
	if not tc:IsLevelAbove(1) and not tc:IsType(TYPE_XYZ) then return false end
	local stat_c=(c:IsType(TYPE_XYZ)) and c:GetRank() or c:GetLevel()
	local stat_tc=(tc:IsType(TYPE_XYZ)) and tc:GetRank() or tc:GetLevel()
	return c:IsFaceup() and c:IsSetCard(0x460) and stat_c>stat_tc
		and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Damage(tp,1000,REASON_COST)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and tp~=ep and #eg==1
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,0,1,nil,eg:GetFirst()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil,eg:GetFirst()):GetFirst()
	if tc and tc:IsFaceup() and tc:IsSetCard(0x460) and tc:IsType(TYPE_MONSTER) and tc:IsAttribute(ATTRIBUTE_WIND) and tc:IsRace(RACE_WINDBEAST) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(s.lvfilter,tp,LOCATION_MZONE,0,nil)
	if e:GetLabel()==1 and #g>0 then
		for tc in aux.Next(g) do
			local code=(tc:IsType(TYPE_XYZ)) and EFFECT_CHANGE_RANK or EFFECT_CHANGE_LEVEL
			local val=(tc:IsType(TYPE_XYZ)) and tc:GetRank()*2 or tc:GetLevel()*2
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(code)
			e1:SetValue(val)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,0,1,nil,re:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil,re:GetHandler()):GetFirst()
	if tc and tc:IsFaceup() and tc:IsSetCard(0x460) and tc:IsType(TYPE_MONSTER) and tc:IsAttribute(ATTRIBUTE_WIND) and tc:IsRace(RACE_WINDBEAST) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	local g=Duel.GetMatchingGroup(s.lvfilter,tp,LOCATION_MZONE,0,nil)
	if e:GetLabel()==1 and #g>0 then
		for tc in aux.Next(g) do
			local code=(tc:IsType(TYPE_XYZ)) and EFFECT_CHANGE_RANK or EFFECT_CHANGE_LEVEL
			local val=(tc:IsType(TYPE_XYZ)) and tc:GetRank()*2 or tc:GetLevel()*2
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(code)
			e1:SetValue(val)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end

function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end