local s,id=GetID()
function s.initial_effect(c)
	-- 记述了卡名「11772070」
	aux.AddCodeList(c,11772070)
	
	-- ①：从卡组把1只有「11772070」卡名记述的怪兽加入手卡。那之后...
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE) -- 如果是怪兽，请改为 EFFECT_TYPE_IGNITION
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	-- ②：自己场上的5星以上的怪兽被战斗·效果破坏的场合，可以作为代替把墓地的这张卡除外。
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end

-- ==================== 效果①的函数 ====================
function s.thfilter(c)
	return aux.IsCodeListed(c,11772070) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.spfilter(c,e,tp)
	return aux.IsCodeListed(c,11772070) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.relfilter(c)
	return c:IsLevelAbove(5) and c:IsReleasableByEffect()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		
		-- 检索成功后，检查是否可以解放怪兽并适用后续效果
		local cg=Duel.GetMatchingGroup(s.relfilter,tp,LOCATION_MZONE,0,nil)
		local b1=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
		
		-- 如果有可以解放的怪兽，并且后续两个效果至少有一个能处理，则询问是否发动
		if #cg>0 and (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local tg=cg:Select(tp,1,1,nil)
			if Duel.Release(tg,REASON_EFFECT)>0 then
				local op=0
				if b1 and b2 then
					op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
				elseif b1 then
					op=Duel.SelectOption(tp,aux.Stringid(id,2))
				else
					op=Duel.SelectOption(tp,aux.Stringid(id,3))+1
				end
				
				if op==0 then
					-- 适用效果：特殊召唤
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
					if #sg>0 then
						Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
					end
				else
					-- 适用效果：除外对方卡片
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
					local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
					if #rg>0 then
						Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
					end
				end
			end
		end
	end
end

-- ==================== 效果②的函数 ====================
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsLevelAbove(5)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	-- 96 是系统默认的“是否作为代替除外？”的提示文字
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end