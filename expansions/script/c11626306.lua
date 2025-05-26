--隐匿虫母
function c11626306.initial_effect(c)
	c:SetSPSummonOnce(11626306)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_INSECT),2,2)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.linklimit)
	c:RegisterEffect(e0) 
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11626306,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c11626306.hspcon)
	e1:SetTarget(c11626306.LinkTarget)
	e1:SetOperation(c11626306.LinkOperation)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--limit 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)   
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(function (e,c)
	return not c:IsRace(RACE_INSECT)  end) 
	c:RegisterEffect(e2) 
	--up and damage 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e3:SetCode(EVENT_DRAW) 
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCondition(c11626306.udcon) 
	e3:SetOperation(c11626306.udop) 
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(11626306,1))
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCountLimit(1,11626306) 
	e4:SetTarget(c11626306.sttg) 
	e4:SetOperation(c11626306.stop) 
	c:RegisterEffect(e4) 
	--
	local e5=Effect.CreateEffect(c) 
	e5:SetDescription(aux.Stringid(11626306,2))
	e5:SetType(EFFECT_TYPE_QUICK_O) 
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE) 
	e5:SetCountLimit(1,11626306) 
	e5:SetTarget(c11626306.sttg2) 
	e5:SetCost(c11626306.stcost)
	e5:SetOperation(c11626306.stop2) 
	c:RegisterEffect(e5) 
	--
	local e7=Effect.CreateEffect(c) 
	e7:SetDescription(aux.Stringid(11626306,3))
	e7:SetType(EFFECT_TYPE_QUICK_O) 
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE) 
	e7:SetCountLimit(1,11626307) 
	e7:SetTarget(c11626306.sptg) 
	e7:SetOperation(c11626306.spop) 
	c:RegisterEffect(e7) 
	local e8=Effect.CreateEffect(c) 
	e8:SetDescription(aux.Stringid(11626306,4))
	e8:SetType(EFFECT_TYPE_QUICK_O) 
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_MZONE) 
	e8:SetCountLimit(1,11626307) 
	e8:SetTarget(c11626306.sptg2) 
	e8:SetCost(c11626306.stcost)
	e8:SetOperation(c11626306.spop2) 
	c:RegisterEffect(e8) 
end
function c11626306.matfilter(c)
	return c:IsSetCard(0x3220)
end
function c11626306.linklimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x3220)
end
function c11626306.hctfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3220) and c:IsAbleToDeckAsCost()
end
function c11626306.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and Duel.IsExistingMatchingCard(c11626306.hctfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
end
function c11626306.issetcard(c,lc)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3220) and c:IsCanBeLinkMaterial(lc)
end
function c11626306.cfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsFaceup()
end
function c11626306.GetLinkMaterials(tp,f,lc,e)
	local mg=Duel.GetMatchingGroup(c11626306.cfilter,tp,LOCATION_MZONE,0,nil,f,lc,e)
	local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	local mg3=Duel.GetMatchingGroup(c11626306.issetcard,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,lc)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	if mg3:GetCount()>0 then mg:Merge(mg3) end
	return mg
end
function c11626306.hspcon(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=2
				local maxc=2
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,nil,c,e)
				else
					mg=c11626306.GetLinkMaterials(tp,nil,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,nil,c,e) then return false end
					mg:AddCard(lmat)
				end
				--local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				--if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				--Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(Auxiliary.LCheckGoal,minc,maxc,tp,c,nil,lmat)
end
function c11626306.LinkTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=2
				local maxc=2
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,nil,c,e)
				else
					mg=c11626306.GetLinkMaterials(tp,nil,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,nil,c,e) then return false end
					mg:AddCard(lmat)
				end
				--local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				--Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,Auxiliary.LCheckGoal,cancel,minc,maxc,tp,c,nil,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
end
function c11626306.LinkOperation(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Auxiliary.LExtraMaterialCount(g,c,tp)
	local sg=g:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_GRAVE)
	g=g-sg
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
	Duel.ConfirmCards(1-tp,sg)
	Duel.SendtoDeck(sg,nil,2,REASON_MATERIAL+REASON_LINK)
	g:DeleteGroup()
	sg:DeleteGroup()
end
--01
function c11626306.udcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)  
end
function c11626306.udop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if ep~=tp and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then
		Duel.Hint(HINT_CARD,0,11626306) 
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil) 
		local tc=g:GetFirst()  
		local x=0 
		while tc do 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(ev*200) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
		x=x+1  
		tc=g:GetNext() 
		end 
		Duel.Damage(1-tp,ev*200,REASON_EFFECT) 
	end 
end 
--02
function c11626306.sttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,5,nil) end 
end 
function c11626306.stop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,5,nil) then 
		Duel.ConfirmDecktop(1-tp,5) 
		Duel.SortDecktop(tp,1-tp,5) 
	end 
end 
--
function c11626306.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,nil,1,REASON_COST,false,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,nil,1,1,REASON_COST,false,e:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end
function c11626306.sttg2(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,5,nil) and Duel.IsPlayerCanDraw(tp,1) end 
end 
function c11626306.stop2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,5,nil) then 
		Duel.ConfirmDecktop(1-tp,5) 
		Duel.SortDecktop(tp,1-tp,5)
		Duel.Draw(tp,1,REASON_EFFECT)
	end 
end 
--
function c11626306.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3220) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11626306.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,3,nil) end
end
function c11626306.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g)
	Duel.ConfirmDecktop(1-tp,3)
	local dg=Duel.GetDecktopGroup(1-tp,3)
	g:Merge(dg)
	if g:GetCount()>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:FilterSelect(tp,c11626306.spfilter,1,ft,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			Duel.Draw(1-tp,sg:GetCount(),REASON_EFFECT)   
		end
	end
	Duel.ShuffleHand(1-tp)
end
function c11626306.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,3,nil) end
end
function c11626306.spop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	Duel.ConfirmCards(tp,g)
	Duel.ConfirmDecktop(1-tp,3)
	local dg=Duel.GetDecktopGroup(1-tp,3)
	g:Merge(dg)
	if g:GetCount()>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:FilterSelect(tp,c11626306.spfilter,1,ft,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			Duel.Draw(1-tp,sg:GetCount(),REASON_EFFECT)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
	Duel.ShuffleHand(1-tp)
end