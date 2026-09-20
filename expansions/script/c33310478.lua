--幻指解构
--c33310478
local s,id=GetID()
s.VHisc_HUANZHI=true

--自定义指示物
local COUNTER_BLEED=0x356a    --流血指示物

function s.initial_effect(c)
	--发动（永续陷阱）
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	--①：在场的可以发动的效果（1回合1次）。
	--把自己场上1张「幻指」怪兽卡解放才能发动。
	--从手卡·额外卡组表侧表示的卡中把和那只怪兽卡名不同的1只「幻指」怪兽特殊召唤。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	--②：永续效果，不入连锁直接适用。
	--每次对方场上有怪兽特殊召唤成功时，或自己场上的「幻指」怪兽的攻击宣言时，
	--给对方场上表侧表示的1只怪兽放置1个流血指示物。
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(s.counterop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(s.counterop)
	c:RegisterEffect(e3)
end

--============================
--【①】
--============================
--可以解放的「幻指」怪兽卡（自己场上）
function s.relfilter(c)
	return c.VHisc_HUANZHI and c:IsType(TYPE_MONSTER) and c:IsReleasable() and c:IsFaceup()
end

--可以特殊召唤的「幻指」怪兽（手卡·额外卡组表侧表示）
function s.spfilter(c,e,tp,code)
	if not (c.VHisc_HUANZHI and c:IsType(TYPE_MONSTER)) then return false end
	if code and c:IsCode(code) then return false end
	if c:IsLocation(LOCATION_EXTRA) and not c:IsFaceup() then return false end
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

--与解放的怪兽卡名不同
function s.pairfilter(c,code)
	return not c:IsCode(code)
end

function s.relpair(rc,mg)
	return mg:IsExists(s.pairfilter,1,nil,rc:GetCode())
end

--存在「解放对象 + 卡名不同的特召对象」的组合才可发动
function s.canactivate(e,tp)
	local rg=Duel.GetMatchingGroup(s.relfilter,tp,LOCATION_MZONE,0,nil)
	if rg:GetCount()==0 then return false end
	local mg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp,nil)
	if mg:GetCount()==0 then return false end
	return rg:IsExists(s.relpair,1,nil,mg)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return s.canactivate(e,tp) end
	--cost：解放自己场上1张「幻指」怪兽卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectReleaseGroup(tp,s.relfilter,1,1,nil)
	local code=rg:GetFirst():GetCode()
	Duel.Release(rg,REASON_COST)
	e:SetLabel(code)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp,code)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=sg:Select(tp,1,1,nil):GetFirst()
	if sc then Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) end
end

--============================
--【②】
--============================
--对方场上的怪兽
function s.oppfilter(c,p)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(p)
end

--可以放置流血指示物的对方怪兽
function s.bleedfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(COUNTER_BLEED,1)
end

function s.counterop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() then return end
	--事件判定：对方怪兽特殊召唤成功，或自己「幻指」怪兽攻击宣言
	if e:GetCode()==EVENT_SPSUMMON_SUCCESS then
		if not eg:IsExists(s.oppfilter,1,nil,1-tp) then return end
	else
		local ac=Duel.GetAttacker()
		if not (ac and ac:IsControler(tp) and ac.VHisc_HUANZHI) then return end
	end
	if Duel.GetMatchingGroupCount(s.bleedfilter,tp,0,LOCATION_MZONE,nil)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local tc=Duel.SelectMatchingCard(tp,s.bleedfilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	tc:AddCounter(COUNTER_BLEED,1)
end
