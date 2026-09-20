--幻指作成
--c33310479
local s,id=GetID()
s.VHisc_HUANZHI=true

--自定义指示物
local COUNTER_INSPIRE=0x556a  --灵感指示物

function s.initial_effect(c)
	--这张卡可以放置灵感指示物
	c:EnableCounterPermit(COUNTER_INSPIRE)
	--这张卡放置的指示物数量最多为3个
	c:SetCounterLimit(COUNTER_INSPIRE,3)
	--发动（场地魔法）
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	--①：自己的主要阶段才能发动。从卡组·墓地把1只「幻指」灵摆怪兽表侧加入额外卡组，在这张卡上放置3个灵感指示物。自己的灵摆区域有「幻指」怪兽存在的场合，可以再让双方受到500伤害。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_COUNTER+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.extratg)
	e1:SetOperation(s.extraop)
	c:RegisterEffect(e1)

	--②：每次对方场上有怪兽特殊召唤成功时，在这张卡上放置1个灵感指示物（最多3个）。因为这个效果把灵感指示物变成3个的场合，可以从以下宣言中选1个对那只怪兽进行。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.cntcon)
	e2:SetTarget(s.cnttg)
	e2:SetOperation(s.cntop)
	c:RegisterEffect(e2)
end

--============================
--【①】
--============================
--「幻指」灵摆怪兽
function s.exfilter(c)
	return c.VHisc_HUANZHI and c:IsType(TYPE_PENDULUM)
end

--自己灵摆区域的「幻指」怪兽
function s.penfilter(c)
	return c.VHisc_HUANZHI and c:IsType(TYPE_PENDULUM)
end

function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,e:GetHandler(),3,0,COUNTER_INSPIRE)
end

function s.extraop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--在这张卡上放置1个灵感指示物
	c:AddCounter(COUNTER_INSPIRE,1)
	--自己的灵摆区域有「幻指」怪兽存在的场合，可以再让双方受到500伤害
	if not Duel.IsExistingMatchingCard(s.penfilter,tp,LOCATION_PZONE,0,1,nil) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end
	Duel.BreakEffect()
	Duel.Damage(1-tp,500,REASON_EFFECT)
	Duel.Damage(tp,500,REASON_EFFECT)
end

--============================
--【②】
--============================
function s.cntfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(1-tp)
end

function s.cntcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cntfilter,1,nil,tp)
end

function s.cnttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(COUNTER_INSPIRE)<3 end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,e:GetHandler(),1,0,COUNTER_INSPIRE)
end

function s.cntop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local ct=c:GetCounter(COUNTER_INSPIRE)
	if ct>=3 then return end
	c:AddCounter(COUNTER_INSPIRE,1)
	--if c:GetCounter(COUNTER_INSPIRE)<3 then return end
	--因为这个效果把灵感指示物变成3个的场合，可以从以下宣言中选1个对那只怪兽进行
	local tc=eg:Filter(s.cntfilter,nil,tp):GetFirst()
	if not tc then return end
	local op=Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,5),aux.Stringid(id,6))
	--仅向双方出示所选宣言（风味文字），无其他特殊处理
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(id,4+op))
	e1:SetReset(RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end
