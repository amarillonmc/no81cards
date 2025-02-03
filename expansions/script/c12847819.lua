--自由之歌
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--zone limit 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MUST_USE_MZONE) 
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE) 
	e0:SetValue(s.frcval)
	c:RegisterEffect(e0)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.movetg)
	e1:SetOperation(s.moveop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1166)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(s.LinkCondition(aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),2,3,gf))
	e3:SetTarget(s.LinkTarget(aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),2,3,gf))
	e3:SetOperation(Auxiliary.LinkOperation(f,min,max,gf))
	e3:SetValue(s.spval)
	c:RegisterEffect(e3)
	if not s.sp_limit_zone then
		s.sp_limit_zone = true
		--splimit
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		ge1:SetTargetRange(1,1)
		ge1:SetTarget(s.splimit)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp)
	if (c:IsHasEffect(id) or c:IsOriginalCodeRule(id)) and not (c:IsLocation(LOCATION_EXTRA) and sumtype==SUMMON_TYPE_LINK) then 
		return not Duel.CheckLocation(targetp,LOCATION_MZONE,2)
	else
		return false
	end
end
function s.frcval(e,c,fp,rp,r)
	return 4 | ((4&0xffff)<<16)|((4>>16)&0xffff) | 0x600060
end
function s.cfilter(c)
	return c:GetSequence()>=5
end
function s.seqfilter(c)
	return c:GetSequence()<=4
end
function s.seqfilter2(c)
	return (c:GetSequence()==1 and c:IsLinkMarker(LINK_MARKER_RIGHT))
	or (c:GetSequence()==3 and c:IsLinkMarker(LINK_MARKER_LEFT))
	or (c:GetSequence()==5 and c:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT))
	or (c:GetSequence()==6 and c:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT))
end
function s.seqfilter3(c)
	if c:IsFacedown() or not c:IsType(TYPE_SPELL) then return false end
	return (c:GetSequence()==1 and c:IsLinkMarker(LINK_MARKER_TOP_RIGHT))
	or (c:GetSequence()==2 and c:IsLinkMarker(LINK_MARKER_TOP))
	or (c:GetSequence()==3 and c:IsLinkMarker(LINK_MARKER_TOP_LEFT))
end
function s.seqfilter4(c)
	return (c:GetSequence()==5 and c:IsLinkMarker(LINK_MARKER_TOP_RIGHT))
	or (c:GetSequence()==6 and c:IsLinkMarker(LINK_MARKER_TOP_LEFT))
end
function s.LCheckGoal(sg,tp,lc,gf,lmat)
	local x1=Duel.GetMatchingGroupCount(s.seqfilter2,tp,LOCATION_MZONE,0,nil) 
	local x2=sg:FilterCount(s.seqfilter2,nil)
	if x2>(x1-1) and not Duel.IsExistingMatchingCard(s.seqfilter3,tp,LOCATION_SZONE,0,1,nil) then return false end
	if sg:IsExists(s.cfilter,2,nil) and not Duel.IsExistingMatchingCard(s.seqfilter3,tp,LOCATION_SZONE,0,1,nil) then return false end
	return sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg,lc,tp))
		and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function s.LinkCondition(f,minct,maxct,gf)
	return  function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
				end
				if not (Duel.IsExistingMatchingCard(s.seqfilter2,tp,LOCATION_MZONE,0,1,nil) 
				or Duel.IsExistingMatchingCard(s.seqfilter3,tp,LOCATION_SZONE,0,1,nil)
				or Duel.IsExistingMatchingCard(s.seqfilter4,tp,0,LOCATION_MZONE,1,nil)) then
					mg=mg:Filter(s.seqfilter,nil)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				local cbool=mg:CheckSubGroup(s.LCheckGoal,minc,maxc,tp,c,gf,lmat)
				return cbool
			end
end
function s.LinkTarget(f,minct,maxct,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
				end
				if not (Duel.IsExistingMatchingCard(s.seqfilter2,tp,LOCATION_MZONE,0,1,nil) 
				or Duel.IsExistingMatchingCard(s.seqfilter3,tp,LOCATION_SZONE,0,1,nil)
				or Duel.IsExistingMatchingCard(s.seqfilter4,tp,0,LOCATION_MZONE,1,nil)) then
					mg=mg:Filter(s.seqfilter,nil)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,s.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function s.spval(e,c)
	return SUMMON_TYPE_LINK,0x4
end
function s.filter(c)
	if not (c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsLocation(LOCATION_MZONE)) then return false end
	for p=0,1 do
	local seq=aux.GetColumn(c,p)
	local opp_seq=0
	if seq==1 then
		opp_seq=5
	elseif seq==3 then
		opp_seq=6
	else 
		return false
	end
		if Duel.GetFieldCard(p,LOCATION_MZONE,opp_seq) then
			return false
		end
	end
	return true
end
function s.movetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.moveop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local seq=tc:GetSequence()
		local opp_seq=0
		if seq==1 then
			opp_seq=5 
		elseif seq==3 then 
			opp_seq=6 
		end
		if Duel.GetLocationCount(tp,LOCATION_MZONE,opp_seq)>0 then
			Duel.MoveSequence(tc,opp_seq)
		end
	end
end
function s.spfilter(c)
	return c:IsType(TYPE_LINK) and c:IsAbleToExtra()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) and c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			c:RegisterEffect(e1)
		end
	end
end