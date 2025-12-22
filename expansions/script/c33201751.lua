--界域编织者 通讯协议
local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--link
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_LINK_SPELL_KOISHI)
	e0:SetValue(LINK_MARKER_TOP_LEFT)
	c:RegisterEffect(e0)	
-- 灵摆效果：加入额外卡组
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0)) -- 需要在脚本对应的数据库中添加描述字符串
	e1:SetType(EFFECT_TYPE_IGNITION)	   -- 启动效果
	e1:SetRange(LOCATION_PZONE)		 -- 在灵摆区域发动
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)-- 取对象效果
	e1:SetCountLimit(1, id)			 -- 卡名1回合1次
	e1:SetTarget(s.pentg)
	e1:SetOperation(s.penop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e2:SetCountLimit(1,33211751+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(s.spcon)
	e2:SetValue(s.spval)
	c:RegisterEffect(e2)
end

--e2
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g=Duel.SelectMatchingCard(tp,s.scfilter,tp,LOCATION_DECK,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then Duel.SendtoExtraP(tc,nil,REASON_EFFECT) end  
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=Duel.GetLinkedZone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and (e:GetHandler():IsLocation(LOCATION_HAND) or e:GetHandler():IsFaceup())
end
function s.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())
end

--e1
function s.filter1(c, tp)
	return c:IsFaceup() 
		and c:IsLinkState() 
		and c:IsLevelAbove(0)   
		and Duel.IsExistingMatchingCard(s.filter2, tp, LOCATION_DECK, 0, 1, nil, c:GetLevel())
end
function s.filter2(c, lv)
	return c:IsRace(RACE_CYBERSE) 
		and c:IsType(TYPE_PENDULUM) 
		and c:IsLevel(lv) 
		and c:IsAbleToExtra()
end
function s.pentg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter1(chkc, tp) end
	if chk == 0 then return Duel.IsExistingTarget(s.filter1, tp, LOCATION_MZONE, 0, 1, nil, tp) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	Duel.SelectTarget(tp, s.filter1, tp, LOCATION_MZONE, 0, 1, 1, nil, tp)
end
function s.penop(e, tp, eg, ep, ev, re, r, rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:Filter(Card.IsRelateToEffect,nil,e):GetFirst()
	if tc:IsFaceup() then
		local lv = tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_OPERATECARD)
		local g = Duel.SelectMatchingCard(tp, s.filter2, tp, LOCATION_DECK, 0, 1, 1, nil, lv)
		if #g > 0 then
			Duel.SendtoExtraP(g, nil, REASON_EFFECT)
		end
	end
end