-- 诚心的尽小花
--Duel.LoadScript("c.lua")
-- 诚心的尽小花
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 添加尽小花系列的卡名记述，方便其他卡识别
	aux.AddCodeList(c,60012023)
	
	-- 魔法卡的激活效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end

-- 目标选择函数
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then 
		-- 检查能不能召唤两个token，双方各一个
		return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,60012024,0,TYPES_TOKEN_MONSTER,1500,1500,3,RACE_FIEND,ATTRIBUTE_DARK)
			and Duel.IsPlayerCanSpecialSummonMonster(1-tp,60012024,0,TYPES_TOKEN_MONSTER,1500,1500,3,RACE_FIEND,ATTRIBUTE_DARK)
	end
	-- 选择要破坏的卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end

-- 效果执行函数
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	-- 先破坏对象卡
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	
	-- 给自己场上召唤伊鞠的小鬼token
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,60012024,0,TYPES_TOKEN_MONSTER,1500,1500,3,RACE_FIEND,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,60012024)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			-- 给token加素材限制效果，照着你给的图3的写法
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e1:SetValue(1)
			e1:SetCondition(cm.act3_con)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			token:RegisterEffect(e2)
		end
	end
	
	-- 给对方场上召唤伊鞠的小鬼token
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(1-tp,60012024,0,TYPES_TOKEN_MONSTER,1500,1500,3,RACE_FIEND,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(1-tp,60012024)
		if Duel.SpecialSummonStep(token,0,1-tp,1-tp,false,false,POS_FACEUP) then
			-- 给token加素材限制效果，照着你给的图3的写法
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e1:SetValue(1)
			e1:SetCondition(cm.act3_con)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			token:RegisterEffect(e2)
		end
	end
	
	Duel.SpecialSummonComplete()
end

-- 图3的条件函数，照着你给的写法，检查玩家是否被伊鞠的全局效果影响
function cm.act3_con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsPlayerAffectedByEffect(tp,60012023)
end

