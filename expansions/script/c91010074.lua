--焰冠圣女
local cm,m=GetID()
function c91010074.initial_effect(c)
	--Link属性设定
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),3,5)
	
	--基本属性
	
	--① 破坏复活+抽卡
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.recon)
	e1:SetOperation(cm.reop)
	c:RegisterEffect(e1)
	
	--② 攻击宣言时破坏
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2)
	e2:SetTarget(cm.atktg)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
	
	--③ 攻击力上升
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
local cl=Effect.CreateEffect(c)
cl:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
cl:SetCode(EVENT_PHASE+PHASE_END)
cl:SetCountLimit(1)
cl:SetOperation(cm.clear)
Duel.RegisterEffect(cl,0)
--全局记录器
local prev=Effect.CreateEffect(c)
prev:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
prev:SetCode(EVENT_DESTROYED)
prev:SetOperation(cm.record)
Duel.RegisterEffect(prev,0)
	cm[0]=0
	cm[1]=0
	cm.attack_record={}
--回合结束清空记录
end

function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm.attack_record={}
end

function cm.record(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsPreviousLocation(LOCATION_MZONE) then
			table.insert(cm.attack_record,{
				turn=Duel.GetTurnCount(),
				attack=tc:GetBaseAttack()
			})
		end
	end
end
--Link召唤条件验证
function cm.lcheck(g)
	return g:GetClassCount(Card.GetOriginalAttribute)==1 and g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE)
end

--①效果处理
function cm.fit(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY)and c:GetTurnID()==Duel.GetTurnCount()
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end

function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0  and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

--②效果处理

function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--③攻击力计算
function cm.atkfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end

function cm.atkval(e,c)
	local tp=c:GetControler()
	local sum=0
	for _,v in pairs(cm.attack_record) do
		if v.turn==Duel.GetTurnCount() then
			sum=sum+v.attack
		end
	end
	return sum
end
