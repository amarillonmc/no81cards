if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53716011
local cm=_G["c"..m]
cm.name="断片折光 幻想魔裔"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,2))
	e7:SetCategory(CATEGORY_TOGRAVE)
	e7:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e7:SetCode(EVENT_RELEASE)
	e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e7:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)end)
	e7:SetTarget(cm.target)
	e7:SetOperation(cm.operation)
	c:RegisterEffect(e7)
end
function cm.fselect(g,ft)
	return g:IsExists(function(c)return c:IsLocation(LOCATION_SZONE) and c:GetSequence()~=5 and c:IsFaceup()end,1,nil) or ft>0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local costg=Duel.GetMatchingGroup(function(c)return c:IsType(TYPE_CONTINUOUS) and c:IsReleasable()end,tp,LOCATION_ONFIELD,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return costg:CheckSubGroup(cm.fselect,3,3,ft) and not e:GetHandler():IsForbidden() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=costg:SelectSubGroup(tp,cm.fselect,false,3,3,ft)
	local cg=g:Filter(Card.IsFacedown,nil)
	if #cg>0 then Duel.ConfirmCards(1-tp,cg) end
	local list={}
	for tc in aux.Next(g) do
		if tc:IsLocation(LOCATION_SZONE) and tc:GetSequence()~=5 then table.insert(list,tc:GetSequence()) end
	end
	if #list>0 then
		table.insert(list,5)
		e:SetLabel(table.unpack(list))
	else e:SetLabel(5) end
	Duel.Release(g,REASON_EFFECT)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local list={e:GetLabel()}
	local c=e:GetHandler()
	local chkl=0
	for cl=0,4 do if Duel.CheckLocation(tp,LOCATION_SZONE,cl) and not SNNM.IsInTable(cl,list) then chkl=1 end end
	if not c:IsRelateToEffect(e) or chkl==0 then return end
	local filter=0
	for i=1,#list do filter=filter|1<<(list[i]+8) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local flag=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,filter)
	if flag and rsop.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true,2^(math.log(flag,2)-8)) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Recover(tp,1800,REASON_EFFECT)
		end
	end
end
function cm.filter(c,e)
	local se=e:GetHandler():GetPreviousSequence()
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then seq=aux.MZoneSequence(c:GetSequence()) end
	return seq<5 and math.abs(se-math.abs(seq-4))==1
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.filter(chkc,e) and chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_ONFIELD,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_ONFIELD,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SendtoGrave(tc,REASON_EFFECT) end
end
