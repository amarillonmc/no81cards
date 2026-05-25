-- 奥夜花的开战
--Duel.LoadScript("c.lua")
-- 奥夜花的开战
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 添加奥夜花系列的卡名记述，方便其他卡识别
	aux.AddCodeList(c,60012030)
	
	-- 速攻魔法的激活效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end

-- 触发条件：自己场上有其他卡存在
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)>=1
end

-- 没有等级的怪兽的过滤
function cm.filter_sp(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()==0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 目标函数
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

-- 效果执行
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 让对方选择选项
	local b1=Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,c)
	local b2=Duel.IsExistingMatchingCard(cm.filter_sp,tp,0,LOCATION_EXTRA,1,nil,e,tp)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
	
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(1-tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b2 then
		op=1
	elseif b1 then
		op=0
	end
	
	if op==0 then
		-- 选项1：选对方场上1张卡回到持有者手卡，对方抽2张
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,c)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.Draw(1-tp,2,REASON_EFFECT)
		end
	elseif op==1 then
		-- 选项2：从额外卡组特殊召唤无等级的怪兽
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(1-tp,cm.filter_sp,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			-- 限制：不能发动效果，不能当各种召唤的素材
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			tc:RegisterEffect(e3)
			local e4=e2:Clone()
			e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			tc:RegisterEffect(e4)
			local e5=e2:Clone()
			e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			tc:RegisterEffect(e5)
		end
	end
end
