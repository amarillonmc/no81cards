--红 之 印 象 惑 虫 奸 乐 之 穴
local m=22348062
local cm=_G["c"..m]
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e1,e1_1,e2,e3=SNNM.ActivatedAsSpellorTrap(c,0x4,LOCATION_SZONE,true)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c22348062.Condition)
	e1:SetTarget(c22348062.target)
	e1:SetOperation(c22348062.operation)
	e1_1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetRange(0xff)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MONSTER_SSET)
	e4:SetValue(TYPE_TRAP)
	c:RegisterEffect(e4)
	--SendtoGrave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22348062,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetTarget(c22348062.target)
	e5:SetOperation(c22348062.operation)
	c:RegisterEffect(e5)
	--SpecialSummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22348060,2))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCondition(c22348062.spcon)
	e6:SetCost(aux.bfgcost)
	e6:SetTarget(c22348062.sttg)
	e6:SetOperation(c22348062.stop)
	c:RegisterEffect(e6)
end
function c22348062.tgfilter(c)
	return c:IsAttackAbove(1000) and c:IsFaceup()
end
function c22348062.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c22348062.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c22348062.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c22348062.setfilter(c)
	return c:IsSetCard(0x3702) and c:IsType(TYPE_MONSTER)
end
function c22348062.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then 
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:GetPreviousControler()==tp and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c22348062.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22348062,2)) then
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			 local g=Duel.SelectMatchingCard(tp,c22348062.setfilter,tp,LOCATION_DECK,0,1,1,nil)
			 local tc1=g:GetFirst()
			 if tc1 then
			  Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
			  local e1=Effect.CreateEffect(e:GetHandler())
			  e1:SetCode(EFFECT_CHANGE_TYPE)
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			  e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			  e1:SetValue(TYPE_TRAP)
			  tc1:RegisterEffect(e1)
			 end
			 Duel.ConfirmCards(1-tp,tc1)
		end
	end
end
function c22348062.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP)
end
function c22348062.stfilter(c,e,tp)
	return (c:IsSetCard(0x3702) or c:GetType()==TYPE_TRAP) and ((c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)) or ((c:IsType(TYPE_FIELD) or (c:IsType(TYPE_TRAP+TYPE_SPELL) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)) and c:IsSSetable(true)))
end
function c22348062.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c22348062.stfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) end
end
function c22348062.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c22348062.stfilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
	local tc=g:GetFirst()
	Debug.Message(tc:GetType())
	if tc and g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,tc)
	elseif tc and g:IsExists(Card.IsType,1,nil,TYPE_TRAP+TYPE_SPELL) and (g:IsExists(Card.IsType,1,nil,TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
		Duel.SSet(tp,tc)
	end
end
function c22348062.Condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetType()==TYPE_TRAP and (Duel.GetTurnCount()~=c:GetTurnID() or c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN))
end

