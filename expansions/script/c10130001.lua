--幻层驱动器 阻隔层
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10130001
local cm=_G["c"..m]
if not rsv.QuantumDriver then
	rsv.QuantumDriver={}
	rsqd=rsv.QuantumDriver
function rsqd.FlipFun(c,code,cate,tg,op)
	local e1=rsef.STO(c,EVENT_FLIP,{code,0},{1,code},{cate,"pos"},"de",nil,nil,tg,rsqd.flipop(op))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	return e1
end
function rsqd.flipop(extraop)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=rscf.GetRelationThisCard(e)
		if c and not c:IsStatus(STATUS_BATTLE_DESTROYED) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and c:IsCanTurnSet() and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
			Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
		end
		extraop(e,tp,eg,ep,ev,re,r,rp)
	end
end
function rsqd.FlipFun2(c,code,cate,flag,tg,op)
	local e1=rsef.STO(c,EVENT_FLIP,{code,0},{1,code+100},{cate,"pos"},{"de",flag},nil,nil,tg,op)
	local e2=rsef.RegisterClone(c,e1,"code",EVENT_TO_GRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	return e1,e2
end
function rsqd.SetFun(tc,e,tp)
	if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
		Duel.SSet(tp,Group.FromCards(tc))
		Duel.ConfirmCards(1-tp,tc)
	else
	   if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
		   Duel.ConfirmCards(1-tp,tc)
	   end
	end 
end
function rsqd.SetFilter(c,e,tp)
	return ((c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable())
end
function rsqd.SetCode(c)
	if not rsqd.SetFun_Switch then 
		rsqd.SetFun_Switch=true
		local e1=rsef.FC({c,0},EVENT_CHANGE_POS)
		e1:RegisterSolve(rsqd.setcon,nil,nil,rsqd.setop)
		local e2=rsef.RegisterClone({c,0},e1,"code",EVENT_SPSUMMON_SUCCESS)
		local e3=rsef.RegisterClone({c,0},e1,"code",EVENT_MSET)
	end
end
function rsqd.setop(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(Card.IsFacedown,nil)
	if #sg>0 then
		Duel.RaiseEvent(sg,m,e,REASON_EFFECT,rp,ep,ev)
	end
end
function rsqd.shcon(e,tp,eg)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function rsqd.shfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function rsqd.ShuffleOp(e,tp)
	local sg=Duel.GetMatchingGroup(rsqd.shfilter,tp,LOCATION_MZONE,0,nil)
	Duel.ShuffleSetCard(sg)
end
function rsqd.ContinuousFun(c)
	--local e1=rsef.SV_IMMUNE_EFFECT(c,nil,rscon.excard(Card.IsFacedown,LOCATION_MZONE))
	local e2=rsef.FTO(c,m,{m,3},nil,nil,"de,dsp",LOCATION_SZONE,rsqd.shcon,nil,rsop.target(rsqd.shfilter,nil,LOCATION_MZONE),rsqd.ShuffleOp)
	--return e1,e2
	return e2
end
---------------
end
---------------
if cm then
function cm.initial_effect(c)
	rsqd.SetCode(c)
	local e1=rsqd.FlipFun(c,m,"se,th",rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.op)
	local e2=rsef.FTO(c,m,{m,1},{1,m+100},"sp","de,dsp",LOCATION_HAND,cm.spcon,nil,rsop.target(cm.spfilter,"sp"),cm.spop)
	cm.QuantumDriver_EffectList={e1,e2}
end
function cm.thfilter(c)
	return c:IsSetCard(0xa336) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.op(e,tp)
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function cm.spcon(e,tp,eg)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
		Duel.ConfirmCards(1-tp,c)
	end
end
---------------
end
