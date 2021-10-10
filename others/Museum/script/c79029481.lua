--个人行动-镜中虚影
function c79029481.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xa904),aux.FilterBoolFunction(Card.IsFusionType,TYPE_TRAP),2,2,true)  
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_ONFIELD,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c79029481.splimit)
	c:RegisterEffect(e1)
	--battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029481,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,79029481)
	e3:SetCost(c79029481.stcost)
	e3:SetTarget(c79029481.sttg)
	e3:SetOperation(c79029481.stop)
	c:RegisterEffect(e3)
	--th or sp
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79029481,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,19029481)
	e4:SetCost(c79029481.tscost)
	e4:SetTarget(c79029481.tstg)
	e4:SetOperation(c79029481.tsop)
	c:RegisterEffect(e4)
end
function c79029481.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c79029481.ctfil(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xa904) and c:IsType(TYPE_MONSTER)
end
function c79029481.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029481.ctfil,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029481.ctfil,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c79029481.stfilter(c)
	return (c:IsSetCard(0xc90e) or c:IsSetCard(0xb90d)) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c79029481.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029481.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c79029481.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c79029481.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
	Debug.Message("给与引导，这我不陌生。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029481,2))
	Duel.SSet(tp,g:GetFirst())
	end
end 
function c79029481.xxfil(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_TRAP)
end
function c79029481.tscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029481.xxfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029481.xxfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c79029481.tsfilter(c,e,tp,ft)
	return c:IsSetCard(0xa904) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c79029481.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029481.tsfilter,tp,LOCATION_DECK,0,1,nil,e,tp,ft) end
end
function c79029481.tsop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c79029481.tsfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	if tc:IsCode(79029203) then 
	Debug.Message("这片黑暗是庇护所，也是宝座，更是乐园。过去的亡灵从未离去，而我在他们的骸骨上诅咒这一切......看到我这副模样，你还想聆听我的歌声，你还敢...站在我身前吗？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029481,6))
	else
	Debug.Message("演员是台词的傀儡。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029481,4))	
	end
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
	if tc:IsCode(79029203) then 
	Debug.Message("这一步无法回头，无法后望。我将与你分享的东西，恐怕并不像你想象中那样美妙。......过来，来这里，这黑夜的幕布，就让我为你揭开。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029481,5))
	else
	Debug.Message("戏剧该揭开它的帷幕了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029481,3))
	end
		end
	end
end




