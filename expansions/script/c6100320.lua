--落日残响·群愿·Awaken
local s,id,o=GetID()
function s.initial_effect(c)
	--融合召唤
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,6100314,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),1,true,true)
	
	--①：回收怪兽 + 卡组解放陷阱
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	--②：改写效果（只用本家素材时获得）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.chcon)
	e2:SetCost(s.chcost)
	e2:SetTarget(s.chtg)
	e2:SetOperation(s.chop)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	e0:SetLabelObject(e2)
	c:RegisterEffect(e0)
	
	--③：遗言
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.regcon)
	e3:SetTarget(s.regtg)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_RELEASE)
	c:RegisterEffect(e4)
end

-- === 效果① ===
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

function s.thfilter(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,0,tp,LOCATION_DECK)
end

function s.relfilter(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_TRAP) and c:IsAbleToGrave()
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tc)
		-- 选卡组陷阱解放
		if Duel.IsExistingMatchingCard(s.relfilter,tp,LOCATION_DECK,0,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local g=Duel.SelectMatchingCard(tp,s.relfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				-- 模拟从卡组解放
				Duel.SendtoGrave(g,REASON_EFFECT+REASON_RELEASE)
			end
		end
	end
end

-- === 效果② ===
function s.mfilter(c)
	return not c:IsSetCard(0x614)
end
function s.valcheck(e,c)
	local mg=c:GetMaterial()
	if mg:GetCount()>0 and not mg:IsExists(s.mfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()==1 and rp==1-tp 
		and ((re:GetActivateLocation()==LOCATION_HAND) or (re:GetActivateLocation()==LOCATION_GRAVE))
end

function s.costfilter(c)
	-- 公开的手卡 OR 表侧的场上卡
	return c:IsSetCard(0x614) and c:IsReleasable()
		and ( (c:IsLocation(LOCATION_HAND) and c:IsPublic()) or (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup()) )
end

function s.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g) -- 清除原对象(可选)
	Duel.ChangeChainOperation(ev,s.repop)
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	-- 这里的 e 是原效果，e:GetHandler() 是发动该效果的卡（对方手卡的卡）
	Duel.Release(e:GetHandler(),REASON_EFFECT)
end

-- === 效果③ ===
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return (rp==1-tp and e:GetHandler():IsPreviousControler(tp)) or (e:GetHandler():IsReason(REASON_EFFECT) and re and re:GetHandler()~=e:GetHandler())
end

function s.regfilter(c)
	return c:IsCode(6100314) and c:IsAbleToHand()
end

function s.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.regfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.regfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end