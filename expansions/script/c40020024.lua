local m=40020024
local cm=_G["c"..m]
function cm.Youthberk(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Youthberk
end
--黎骑转生
function cm.initial_effect(c)
	-- 本卡记述了「烈光之骑士 朱斯」
	aux.AddCodeList(c,40010499)

	--①：检索「烈光之骑士 朱斯」或其记述卡，然后作为素材重叠
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end

-- 检索条件：记述「烈光之骑士 朱斯」或是本体
function cm.thfilter(c)
	return (aux.IsCodeListed(c,40010499) or c:IsCode(40010499)) and c:IsAbleToHand()
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end

	-- 可选：将此卡重叠到1只己方「朱斯贝克」超量怪兽下作为素材
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local tg=Duel.SelectMatchingCard(tp,cm.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if #tg>0 then
		Duel.BreakEffect()
		Duel.Overlay(tg:GetFirst(),Group.FromCards(c))
		-- 赋予②效果
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,2))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_TYPE_XMATERIAL)
		e2:SetCondition(cm.matcon)
		e2:SetValue(cm.matval)
		e2:SetOwnerPlayer(tp)
		c:RegisterEffect(e2)
	end
end

-- 筛选字段为0xaf1c的XYZ怪兽
function cm.xyzfilter(c)
	return c:IsType(TYPE_XYZ) and cm.Youthberk(c)
end

--②素材效果赋予条件
function cm.matcon(e)
	return e:GetHandler():IsType(TYPE_XYZ) and cm.Youthberk(e:GetHandler())
end

--②素材赋予效果定义（实际效果实现）
function cm.matval(e,c)
	local eff=Effect.CreateEffect(c)
	eff:SetDescription(aux.Stringid(m,3))
	eff:SetCategory(CATEGORY_SPECIAL_SUMMON)
	eff:SetType(EFFECT_TYPE_IGNITION)
	eff:SetRange(LOCATION_MZONE)
	eff:SetCountLimit(1)
	eff:SetCondition(cm.spcon)
	eff:SetTarget(cm.sptg)
	eff:SetOperation(cm.spop)
	return eff
end

-- 解放条件：素材数量≥2
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=2
end

-- 特召筛选
function cm.spfilter(c,e,tp,code,lv,att)
	return (aux.IsCodeListed(c,40010499) or c:IsCode(40010499))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and ((c:GetLevel()==lv and c:GetAttribute()~=att)
		  or (c:GetLevel()~=lv and c:GetAttribute()==att))
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
			and c:IsReleasable()
			and Duel.IsExistingMatchingCard(cm.spcheckfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end

function cm.spcheckfilter(c,e,tp)
	local lv=c:GetLevel()
	local att=c:GetAttribute()
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,c,e,tp,c:GetCode(),lv,att)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsReleasable() then return end
	Duel.Release(c,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,cm.spcheckfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g1==0 then return end
	local tc1=g1:GetFirst()
	local lv,att=tc1:GetLevel(),tc1:GetAttribute()
	local g2=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,tc1,e,tp,tc1:GetCode(),lv,att)
	if #g2>0 then
		g1:Merge(g2)
		for tc in aux.Next(g1) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
