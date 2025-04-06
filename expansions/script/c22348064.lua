--惧质体 “小丑”
local m=22348064
local cm=_G["c"..m]
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e1,e1_1,e2,e3=SNNM.ActivatedAsSpellorTrap(c,0x4,LOCATION_SZONE,true)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_CONTROL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c22348064.Condition)
	e1:SetTarget(c22348064.target)
	e1:SetOperation(c22348064.operation)
	e1_1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetRange(0xff)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MONSTER_SSET)
	e4:SetValue(TYPE_TRAP)
	c:RegisterEffect(e4)
	--set2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22348064,0))
	e5:SetCategory(CATEGORY_EQUIP+CATEGORY_CONTROL)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetTarget(c22348064.target)
	e5:SetOperation(c22348064.operation)
	c:RegisterEffect(e5)
	--ps
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22348060,2))
	e6:SetCategory(CATEGORY_POSITION+CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCondition(c22348064.pscon)
	e6:SetCost(aux.bfgcost)
	e6:SetTarget(c22348064.pstg)
	e6:SetOperation(c22348064.psop)
	c:RegisterEffect(e6)
end
function c22348064.tgfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsAbleToChangeControler()
		and Duel.IsExistingMatchingCard(c22348064.eqfilter,tp,LOCATION_DECK,0,1,nil)
end
function c22348064.eqfilter(c)
	return c:IsSetCard(0x3702) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c22348064.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c22348064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c22348064.tgfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c22348064.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c22348064.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=Duel.SelectMatchingCard(tp,c22348064.eqfilter,tp,LOCATION_DECK,0,1,1,nil)
	local sc=sg:GetFirst()
	if sc then
		if not Duel.Equip(tp,sc,tc) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c22348064.eqlimit)
		e1:SetLabelObject(tc)
		sc:RegisterEffect(e1)
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end
function c22348064.pscon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP)
end
function c22348064.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c22348064.psop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if g:GetCount()>0 and ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local sg1=g:Select(tp,1,ct,nil)
		if sg1:GetCount()>0 then
			Duel.HintSelection(sg1)
			local aaa=Duel.ChangePosition(sg1,POS_FACEDOWN_DEFENSE)
			if aaa>0 then
				Duel.Draw(tp,aaa,REASON_EFFECT)
			end
		end
	end
end
function c22348064.Condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetType()==TYPE_TRAP and (Duel.GetTurnCount()~=c:GetTurnID() or c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN))
end






