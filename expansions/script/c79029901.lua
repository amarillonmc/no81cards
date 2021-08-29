--深海猎人·行动-碎璇狂舞
function c79029901.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029901)
	e1:SetTarget(c79029901.actg)
	e1:SetOperation(c79029901.acop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,09029901)
	e2:SetCondition(c79029901.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79029901.sptg)
	e2:SetOperation(c79029901.spop)
	c:RegisterEffect(e2)
end
c79029901.named_with_AbyssHunter=true 
function c79029901.filter(c)
	return c.named_with_AbyssHunter and c:IsAbleToHand()
end
function c79029901.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029901.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029901.tdfil(c)
	return c:IsAbleToDeck() and c:IsSetCard(0xa900,0xb90d,0xc90e,0xa90f)
end
function c79029901.fzfil(c)
	return not c:IsLocation(LOCATION_FZONE)
end
function c79029901.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Debug.Message("小心了，海流会追索脆弱的生命。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029901,2))   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029901.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	local chk=true  
	while chk do
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,79029459) and Duel.IsExistingMatchingCard(c79029901.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil):GetCount()>=2 and Duel.SelectYesNo(tp,aux.Stringid(79029901,0)) then 
	local sg=Duel.SelectMatchingCard(tp,c79029901.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(sg,tp,2,REASON_EFFECT)
	local mg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil):RandomSelect(tp,2)
	local tc1=mg:GetFirst()
	local tc2=mg:GetNext()
	Duel.SwapSequence(tc1,tc2)
	Duel.Damage(1-tp,500,REASON_EFFECT)
	if c:GetFlagEffect(79029901)==0 then 
	Debug.Message("想从我掌间逃开前征求过我的同意了吗，我的猎物？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029901,3))	
	end
	c:RegisterFlagEffect(79029901,0,0,0)
	else
	Debug.Message("戏弄玩具的时间到此结束。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029901,4))	
	chk=false 
	c:ResetFlagEffect(79029901)
	end
	end
	end
end
function c79029901.ckfil(c,tp)
	return c.named_with_AbyssHunter and c:IsType(TYPE_MONSTER) and c:GetPreviousControler()==tp 
end
function c79029901.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029901.ckfil,1,nil,tp) 
end
function c79029901.spfil(c,e,tp)
	return c:IsCode(79029459) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) 
end
function c79029901.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029901.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c79029901.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029901.spfil,tp,LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	Debug.Message("不用太在意自己深陷泥泞般的速度，我可以放慢脚步等你们。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029901,5))  
	end
end




