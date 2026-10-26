--襄武义汉 皇甫嵩
-- 卡片脚本 ID 声明
local s,id=GetID()
local GID=id
function s.initial_effect(c)
	--summon with 3 tribute
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(98990003,2))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e0:SetCondition(c98990003.ttcon)
	e0:SetOperation(c98990003.ttop)
	e0:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c98990003.setcon)
	c:RegisterEffect(e2)
	-- ①：召唤·从场上送去墓地
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.thcon1)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_TO_GRAVE)
	e1b:SetCondition(s.thcon2)
	c:RegisterEffect(e1b)

	-- ②：手卡·场上最小等级怪兽发效果时
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCondition(s.handcon)
	e2:SetTarget(s.handtg)
	e2:SetOperation(s.handop)
	c:RegisterEffect(e2)

	-- ③：主要阶段发动（决斗中只能使用1次）
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e3:SetOperation(s.effop3)
	c:RegisterEffect(e3)
	
	if not c98990003.global_check then
		c98990003.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DAMAGE)
		ge1:SetOperation(c98990003.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function c98990003.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ev>0 then 
	   s.addvalue(p,ev) end
end

function s.addvalue(p,val)
	local old=Duel.GetFlagEffectLabel(p,GID)
	if old then
		Duel.SetFlagEffectLabel(p,GID,old+val)
	else
		Duel.RegisterFlagEffect(p,GID,RESET_PHASE+PHASE_END,0,1,val)
	end
end

function s.getvalue(p)
	return Duel.GetFlagEffectLabel(p,GID) or 0
end

-- 标记定义
-- id+300: 决斗中不能发动①的效果
-- id+400: 决斗中不能发动②的效果
-- id+500: 本回合不能发动①的效果（墓地发动后的限制）
-- id+100: 本回合已确认过自己的手卡
-- id+200: 本回合已确认过对方的手卡

-----------------------------------------------------------------
-- ①的效果
-----------------------------------------------------------------
function c98990003.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c98990003.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c98990003.setcon(e,c,minc)
	if not c then return true end
	return false
end
function s.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id+300)==0 and Duel.GetFlagEffect(tp,id+500)==0
end

function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and Duel.GetFlagEffect(tp,id+300)==0 
		and Duel.GetFlagEffect(tp,id+500)==0
end

function s.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()>0 and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK+LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_MZONE)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=Duel.SelectOption(tp,aux.Stringid(id,7),aux.Stringid(id,8))
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	local g1=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if op==1 then
		 g=g1
	end

	-- 获取最低等级
	local min_lv=99
	for tc in aux.Next(g) do
		local lv=tc:GetLevel()
		if lv<min_lv then min_lv=lv end
	end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:FilterSelect(tp,function(c) return c:GetLevel()==min_lv end,1,1,nil)
	if #sg>0 and Duel.SendtoHand(sg,tp,REASON_EFFECT)>0 and sg:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,sg)
		local added_card=sg:GetFirst()
		-- 如果加手的是1星怪兽，且自身在墓地，则无视召唤条件特召
		if added_card:IsLevel(1) then
			Duel.BreakEffect()
			Duel.RegisterFlagEffect(tp,id+500,RESET_PHASE+PHASE_END,0,1)
			if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) 
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
end

-----------------------------------------------------------------
-- ②的效果
-----------------------------------------------------------------
function s.handcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id+400)>0 then return false end
	if not re:IsActiveType(TYPE_MONSTER) or rp~=tp then return false end
	
	-- 必须是在手卡或场上发动的怪兽
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if not (loc==LOCATION_HAND or loc==LOCATION_MZONE) then return false end

	-- 获取自己手卡和场上的所有怪兽
	local g=Duel.GetMatchingGroup(function(c) return c:IsType(TYPE_MONSTER) and c:GetLevel()>0 end,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if #g==0 then return false end

	local min_lv=99
	for tc in aux.Next(g) do
		local lv=tc:GetLevel()
		if lv<min_lv then min_lv=lv end
	end

	local rc=re:GetHandler()
	return rc:IsType(TYPE_MONSTER) and rc:GetLevel()==min_lv
end

function s.handtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1 = (Duel.GetFlagEffect(tp,id+100)==0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0)
	local b2 = (Duel.GetFlagEffect(tp,id+200)==0 and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0)
	if chk==0 then return b1 or b2 end
end

function s.handop(e,tp,eg,ep,ev,re,r,rp)
	local b1 = (Duel.GetFlagEffect(tp,id+100)==0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0)
	local b2 = (Duel.GetFlagEffect(tp,id+200)==0 and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0)

	if not b1 and not b2 then return end

	local target_player=tp
	if b1 and b2 then
		local op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4)) -- 确认自己手卡 / 确认对方手卡
		if op==1 then target_player=1-tp end
	elseif b2 then
		target_player=1-tp
	end

	-- 标记该玩家本回合已被确认过
	if target_player==tp then
		Duel.RegisterFlagEffect(tp,id+100,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.RegisterFlagEffect(tp,id+200,RESET_PHASE+PHASE_END,0,1)
	end

	local hand=Duel.GetFieldGroup(target_player,LOCATION_HAND,0)
	if #hand==0 then return end

	Duel.ConfirmCards(tp,hand)
	local mg=hand:Filter(function(c) return c:IsType(TYPE_MONSTER) and c:GetLevel()>0 end,nil)
	
	if #mg>0 then
		local min_lv=99
		for tc in aux.Next(mg) do
			local lv=tc:GetLevel()
			if lv<min_lv then min_lv=lv end
		end

		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=mg:FilterSelect(tp,function(c) return c:GetLevel()==min_lv end,1,1,nil)
		if #sg>0 then
			Duel.SendtoDeck(sg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
	end
	Duel.ShuffleHand(target_player)

	-- 抽卡直到手卡变为4张
	local hand_count=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if hand_count<4 then
		local draw_count=4-hand_count
		if Duel.Draw(tp,draw_count,REASON_EFFECT)>0 then
			local drawn_g=Duel.GetOperatedGroup()
			Duel.ConfirmCards(1-tp,drawn_g)

			-- 将抽到的怪兽尽可能效果无效特殊召唤
			local monster_g=drawn_g:Filter(Card.IsType,nil,TYPE_MONSTER)
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			if #monster_g>0 and ft>0 then
				if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sp_g=monster_g:Select(tp,0,ft,nil)
				for sp_card in aux.Next(sp_g) do
					if Duel.SpecialSummonStep(sp_card,0,tp,tp,false,false,POS_FACEUP) then
						-- 效果无效化
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_DISABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						sp_card:RegisterEffect(e1)
						local e2=Effect.CreateEffect(e:GetHandler())
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetCode(EFFECT_DISABLE_EFFECT)
						e2:SetReset(RESET_EVENT+RESETS_STANDARD)
						sp_card:RegisterEffect(e2)
					end
				end
				Duel.SpecialSummonComplete()
			end
			Duel.ShuffleHand(tp)
		end
	end
end

-----------------------------------------------------------------
-- ③的效果
-----------------------------------------------------------------
function s.effop3(e,tp,eg,ep,ev,re,r,rp)
	 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1) 
	e1:SetValue(c98990003.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	-- 注册：结束阶段誓约选择
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetOperation(s.endop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c98990003.damval(e,re,val,r,rp)
	local pval=s.getvalue(1-e:GetHandlerPlayer())
	return val+pval
end

function s.endop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	-- 0: 决斗中①的效果不能再发动
	-- 1: 决斗中②的效果不能再发动
	local op=Duel.SelectOption(tp,aux.Stringid(id,5),aux.Stringid(id,6))
	if op==0 then
		Duel.RegisterFlagEffect(tp,id+300,0,0,1)
	else
		Duel.RegisterFlagEffect(tp,id+400,0,0,1)
	end
end