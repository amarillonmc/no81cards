--last upd 2022-1-12
Seine_Metafor={}
local mf=_G["Seine_Metafor"]
mf.arty=0x3312
mf.arcode=31407000
if not mf._Is_Can_Be_Syn_Mat_Hack then
	mf._Is_Can_Be_Syn_Mat_Hack=true
	mf._Is_Can_Be_Syn_Mat=Card.IsCanBeSynchroMaterial
	function Card.IsCanBeSynchroMaterial(c,sc,tuner,loc)
		local con1,con2
		con1=not c:IsLocation(LOCATION_GRAVE)
		if loc then
			con1=c:IsLocation(loc)
		end
		if tuner then
			con2=mf._Is_Can_Be_Syn_Mat(c,sc,tuner)
		else
			con2=mf._Is_Can_Be_Syn_Mat(c,sc)
		end
		return con1 and con2
	end
end
function mf.Grave_Quick_Syn(c)
	local e=Effect.CreateEffect(c)
	e:SetDescription(aux.Stringid(mf.arcode,0))
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e:SetType(EFFECT_TYPE_QUICK_O)
	e:SetCode(EVENT_FREE_CHAIN)
	e:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e:SetRange(LOCATION_GRAVE)
	e:SetTarget(mf.Grave_Quick_Syn_Tg)
	e:SetOperation(mf.Grave_Quick_Syn_Op)
	c:RegisterEffect(e)
end
function mf.Grave_Quick_Syn_Tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	if chk==0 then return not c:IsStatus(STATUS_CHAINING) and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,c,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function mf.Grave_Quick_Syn_Op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c,mg)
	end
end
function mf.Syn_Big_Proc(c,matloc)
	c:EnableReviveLimit()
	local elim=Effect.CreateEffect(c)
	elim:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	elim:SetType(EFFECT_TYPE_SINGLE)
	elim:SetCode(EFFECT_SPSUMMON_CONDITION)
	elim:SetValue(aux.synlimit)
	c:RegisterEffect(elim)
	local esp=Effect.CreateEffect(c)
	esp:SetType(EFFECT_TYPE_FIELD)
	esp:SetCode(EFFECT_SPSUMMON_PROC)
	esp:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	esp:SetRange(LOCATION_EXTRA)
	esp:SetValue(SUMMON_TYPE_SYNCHRO)
	if not matloc then
		esp:SetCondition(mf.Syn_Big_Con)
		esp:SetOperation(mf.Syn_Big_Op)
	else
		esp:SetCondition(mf.Grave_Syn_Big_Con)
		esp:SetOperation(mf.Grave_Syn_Big_Op)
	end
	c:RegisterEffect(esp)
end
function mf.Grave_Syn_Big_Filterc(c,tc) 
	return c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove() and c:IsSynchroType(TYPE_SYNCHRO) and c:IsSynchroType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(tc,nil,LOCATION_GRAVE)
end
function mf.Grave_Syn_Big_Filterg(g,tp,tc,smat)
	if smat then
		g:AddCard(smat)
	end
	if g:FilterCount(mf.Grave_Syn_Big_Filterc,nil,tc)~=#g then return false end
	return g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)==1 and g:GetSum(Card.GetLevel)==tc:GetLevel() and Duel.GetLocationCountFromEx(tp,tp,g,tc)>0
end
function mf.Grave_Syn_Big_Con(e,c,smat,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	if not mg then
		mg=Duel.GetMatchingGroup(Card.IsSynchroType,tp,LOCATION_GRAVE,0,nil,TYPE_TUNER)
	end
	if smat then
		mg:RemoveCard(smat)
		return mg:CheckSubGroup(mf.Grave_Syn_Big_Filterg,2,nil,tp,c,smat)
	else
		return mg:CheckSubGroup(mf.Grave_Syn_Big_Filterg,3,nil,tp,c,nil)
	end
end
function mf.Grave_Syn_Big_Op(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	if not mg then
		mg=Duel.GetMatchingGroup(Card.IsSynchroType,tp,LOCATION_GRAVE,0,nil,TYPE_TUNER)
	end
	local g=Group.CreateGroup()
	if smat then
		mg:RemoveCard(smat)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,mf.Grave_Syn_Big_Filterg,false,2,nil,tp,c,smat))
		g:AddCard(smat)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,mf.Grave_Syn_Big_Filterg,false,3,nil,tp,c,nil))
	end
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
end
function mf.Syn_Big_Filterc(c,tc) 
	return c:IsSynchroType(TYPE_SYNCHRO) and c:IsSynchroType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(tc) and c:IsPosition(POS_FACEUP)
end
function mf.Syn_Big_Filterg(g,tp,tc,smat)
	if smat then
		g:AddCard(smat)
	end
	if g:FilterCount(mf.Syn_Big_Filterc,nil,tc)~=#g then return false end
	return g:FilterCount(Card.IsRace,nil,RACE_DRAGON)==1 and g:GetSum(Card.GetLevel)==tc:GetLevel() and Duel.GetLocationCountFromEx(tp,tp,g,tc)>0
end
function mf.Syn_Big_Con(e,c,smat,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	if not mg then
		mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	end
	if smat then
		mg:RemoveCard(smat)
		return mg:CheckSubGroup(mf.Syn_Big_Filterg,2,nil,tp,c,smat)
	else
		return mg:CheckSubGroup(mf.Syn_Big_Filterg,3,nil,tp,c,nil)
	end
end
function mf.Syn_Big_Op(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	if not mg then
		mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	end
	local g=Group.CreateGroup()
	if smat then
		mg:RemoveCard(smat)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,mf.Syn_Big_Filterg,false,2,nil,tp,c,smat))
		g:AddCard(smat)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,mf.Syn_Big_Filterg,false,3,nil,tp,c,nil))
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end