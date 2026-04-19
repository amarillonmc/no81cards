--夜月色巫女
local s,id,o=GetID()
function s.initial_effect(c)
	--同调召唤
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)

	--①：同调召唤场合的翻卡检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)

	--②：这张卡不会成为对方的效果的对象
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)

	--②：作为同调素材，赋予同调怪兽取对象抗性
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(s.mtcon)
	e3:SetOperation(s.mtop)
	c:RegisterEffect(e3)
end

-- === 效果①：翻卡检索 ===
function s.valcheck(e,c)
	local c=e:GetHandler()
	local ct=c:GetMaterial():FilterCount(s.matfilter,nil)
	local count=ct*3
	if chk==0 then return count>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=count end  
	e:GetLabelObject():SetLabel(ct)
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function s.matfilter(c)
	return c:IsType(TYPE_NORMAL) and not c:IsType(TYPE_TOKEN)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local count=ct*3
	if chk==0 then return count>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=count end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	-- 系统内置字符串 70:怪兽, 71:魔法, 72:陷阱
	local op=Duel.SelectOption(tp,70,71,72)
	e:SetLabel(ct,op)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local count=ct*3
	if count==0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<count then return end
	
	Duel.ConfirmDecktop(tp,count)
	local g=Duel.GetDecktopGroup(tp,count)
	local _,opt=e:GetLabel()
	
	-- 解析宣言的卡片种类
	local ty = 0
	if opt==0 then ty=TYPE_MONSTER
	elseif opt==1 then ty=TYPE_SPELL
	elseif opt==2 then ty=TYPE_TRAP end
	
	-- 筛出符合宣言种类的卡
	local thg=g:Filter(Card.IsType,nil,ty)
	
	-- 如果那之中有宣言的种类的卡，全部加入手卡
	if #thg>0 then
		Duel.DisableShuffleCheck()
		local tthg=thg:Select(tp,1,2,nil)
		Duel.SendtoHand(tthg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tthg)
		Duel.ShuffleHand(tp)
		g:Sub(thg) -- 移出准备加入手卡的卡片
	end
	
	-- 剩下的卡回到卡组洗切
	Duel.ShuffleDeck(tp)
end

-- === 效果②：同调素材附着光环 ===
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end

function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if rc then
		-- 为召唤出的同调怪兽赋予不会成为对方效果的对象的能力
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3061) -- 客户端提示文本："不会成为对方效果的对象"
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetValue(aux.tgoval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1)
	end
end