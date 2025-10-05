--已化为绝海滋养的古舰
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    --自己主要阶段才能发动。自己手卡·场上任意数量的「绝海滋养」怪兽解放，把解放数量的卡从自己卡组上面翻开，从那之中选1张加入手卡，剩下的卡用喜欢的顺序回到卡组下面。
    --「毒枪龙骑士之影灵衣」「疾行机人 吹持童子」
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
    --双方结束阶段才能发动。从自己墓地以及除外的卡（表侧表示）中，选1只「绝海滋养」怪兽加入手卡或特殊召唤。
    --「未来之柱-奇亚诺丝」
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id+o)
	e3:SetTarget(s.thsptg)
	e3:SetOperation(s.thspop)
	c:RegisterEffect(e3)
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5225)
end
function s.gfilter(sg,tp)
    local ct=#sg
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct
		and Duel.GetDecktopGroup(tp,ct):IsExists(Card.IsAbleToHand,1,nil)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetReleaseGroup(tp,true,REASON_EFFECT):Filter(s.filter,nil)
	if chk==0 then return g:CheckSubGroup(s.gfilter,1,#g,tp) end
Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetReleaseGroup(tp,true,REASON_EFFECT):Filter(s.filter,nil)
	local sg=g:SelectSubGroup(tp,s.gfilter,false,1,#g,tp)
    if sg and #sg>0 then
		local ct=Duel.Release(sg,REASON_EFFECT)
        Duel.ConfirmDecktop(tp,ct)
	    local tg=Duel.GetDecktopGroup(tp,ct)
	    if #tg>0 then
	    	Duel.DisableShuffleCheck()
	    	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	    	local sc=tg:Select(tp,1,1,nil):GetFirst()
	    	if sc:IsAbleToHand() then
	    		Duel.SendtoHand(sc,nil,REASON_EFFECT)
	    		Duel.ConfirmCards(1-tp,sc)
	    		Duel.ShuffleHand(tp)
	    	else
	    		Duel.SendtoGrave(sc,REASON_RULE)
	    	end
	    end
	    if #tg>1 then
	    	Duel.SortDecktop(tp,tp,#tg-1)
	    	for i=1,#tg-1 do
	    		local dg=Duel.GetDecktopGroup(tp,1)
	    		Duel.MoveSequence(dg:GetFirst(),SEQ_DECKBOTTOM)
	    	end
	    end
	end
end
function s.thfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5225) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false)) and c:IsFaceupEx()
end
function s.thsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
end
function s.thspop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if tc then
		if not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.SelectOption(tp,1190,1152)==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end