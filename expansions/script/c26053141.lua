-- 雷霆重塑
local m=26053141
local cm=_G["c"..m]
function cm.initial_effect(c)
c:SetUniqueOnField(1,0,m)
    -- ① 发动时的效果处理：破坏场上1张表侧表示的卡
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetTarget(cm.destg)
    e1:SetOperation(cm.desop)
    c:RegisterEffect(e1)
    -- ② 对方从卡组·额外特殊召唤怪兽时，选择1个效果发动
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_TOHAND)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_SZONE)
		e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(cm.condition2)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
end
function cm.filter1(c)
	return c:IsFaceup()
end
-- ① 发动目标：选择场上1张表侧卡
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end

function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)  then
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
            Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
-- ② 条件：对方特殊召唤的怪兽存在从卡组·额外来的
function cm.filter(c,sp)
	return c:IsSummonPlayer(sp)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   local b1=Duel.IsExistingMatchingCard(cm.nofilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,m+1)==0)
	local b2=Duel.IsExistingMatchingCard(cm.nofilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,m+2)==0)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 or b2 then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(m,2),1},
			{b2,aux.Stringid(m,3),2})
	end
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_TOHAND)
			Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_TODECK)
			Duel.RegisterFlagEffect(tp,m+2,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
	end
end
-- 操作：选择并执行一个效果
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.nofilter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif e:GetLabel()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.nofilter1),tp,LOCATION_ONFIELD,0,1,1,nil)
		if g:GetCount()>0 then
			 Duel.SendtoHand(g,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,g)
		end
	end
end

function cm.nofilter1(c)
	return c:IsSetCard(0xeae9) and c:IsAbleToDeck()
end
function cm.nofilter2(c)
	return c:IsSetCard(0xeae9) and c:IsAbleToHand()
end