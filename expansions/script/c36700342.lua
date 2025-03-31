--[[
本lua的作者为藜奴儿，如果测试出bug请联系QQ：1502939196

未经允许不支持任何人的任何形式的修改，源数。如有需要请联系作者，而不是私自找人代为修改。
本人对于本lua的任何bug修改、源数和适配后来卡片均为免费，并且追诉期无限。

但是如果使用者私自修改了lua，不论是bug修复还是源数效果，本人对此lua都不会再提供任何形式的支持。
一旦发现任何其他人对本lua进行了任何形式的修改，本人首先自愿放弃此lua除必要署名权以外的所有权利，
同时再也会不承担对此lua的任何维护与后续适配，包括但不限于任何形式的bug修复、效果源数。

如果您想要修改此lua，可以先联系本人，本人会在第一时间进行回复。
并且我承诺，若本人在2天内没有回复您，上述注意事项可作废，您可以直接修改此lua，而后续debug与适配仍然由我来进行。

如果您对本lua有任何疑问，请联系本人，本人会在第一时间进行回复。
如果您对本lua有任何建议，请联系本人，本人会在第一时间进行处理。
]]
--路鸣泽 火之晨曦
--aux.Stringid(id,0)="解放特殊召唤"
--aux.Stringid(id,1)="应用②效果"
--aux.Stringid(id,2)="装备到怪兽"

local s,id,o=GetID()
function s.initial_effect(c)
	--Link Summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.LinkCondition(s.matfilter,2,2,s.lcheck))
	e0:SetTarget(s.LinkTarget(s.matfilter,2,2,s.lcheck))
	e0:SetOperation(s.LinkOperation(s.matfilter,2,2,s.lcheck))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	
	--Tribute to Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	--Equip from GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+1)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCondition(s.eqcon)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
	s.effect_2=e2

end
function s.LinkCondition(f,minct,maxct,gf)
	return	function(e,c,og,lmat,min,max)
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
					local mgs=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_ONFIELD,0,nil)
					mg:Merge(mgs)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(Auxiliary.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function s.LinkTarget(f,minct,maxct,gf)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
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
					local mgs=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_ONFIELD,0,nil)
					mg:Merge(mgs)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,Auxiliary.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function s.LinkOperation(f,minct,maxct,gf)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Auxiliary.LExtraMaterialCount(g,c,tp)
				s.SzoneExtraMaterial(g,tp)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end
function s.SzoneExtraMaterial(mg,tp)
	for tc in Auxiliary.Next(mg) do
		if tc:IsLocation(LOCATION_SZONE) and tc:IsFacedown() then
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end

--Link material filter
function s.matfilter(c)
	return not c:IsType(TYPE_LINK) and ((c:IsType(TYPE_MONSTER))
	or (c:IsSetCard(0xc50) and c:IsType(TYPE_SPELL+TYPE_TRAP)))
end

function s.racefilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE)
end

--Additional Link summon check
function s.lcheck(g)
	return g:IsExists(s.racefilter,1,nil)
end

--Extra material condition
function s.extracon(c,e,tp,sg,mg,lc,og,chk)
	return not sg or sg:FilterCount(s.flagcheck,nil)<2
end

--Flag check for extra material
function s.flagcheck(c)
	return c:GetFlagEffect(id)>0
end

--Extra material value
function s.extraval(chk,summon_type,e,...)
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_LINK or sc~=e:GetHandler() then
			return Group.CreateGroup()
		else
			return Duel.GetMatchingGroup(s.extramatfilter,tp,LOCATION_ONFIELD,0,nil)
		end
	elseif chk==1 then
		local sg,sc,tp=...
		if summon_type&SUMMON_TYPE_LINK==SUMMON_TYPE_LINK and #sg>0 then
			Duel.Hint(HINT_CARD,tp,id)
			Duel.ConfirmCards(1-tp,sg:Filter(Card.IsFacedown,nil))
		end
	elseif chk==2 then
		local sg,sc,tp,ct=...
		if summon_type&SUMMON_TYPE_LINK==SUMMON_TYPE_LINK and ct>1 then
			Duel.Hint(HINT_CARD,tp,id)
		end
	end
end

--Extra material filter
function s.extramatfilter(c)
	if c:IsLocation(LOCATION_ONFIELD) and c:IsFacedown() then
		local res=c:IsSetCard(0xc50) and c:IsType(TYPE_SPELL+TYPE_TRAP)
		if res then
			c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		return res
	else
		return c:IsSetCard(0xc50) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanBeLinkMaterial() and c:IsOnField()
	end
end

--Special Summon cost
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end

--Special Summon target
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xc50) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

--Special Summon operation
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local eff2=tc.effect_2
		if not eff2 then return end
		local e2t=eff2:GetTarget()
		if (not e2t or e2t(eff2,tp,eg,ep,ev,re,r,rp,0))
			and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			local e2o=eff2:GetOperation()
			local tsg=e2t(eff2,tp,eg,ep,ev,re,r,rp,1)
			if e2o then e2o(eff2,tp,eg,ep,ev,re,505,rp,tsg) end
		end
	end
end

--Equip condition
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end

--Equip target
function s.eqfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0xc50) or c:IsSetCard(0xc51))
end

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end

--Equip operation
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not tc:IsRelateToEffect(e) or tc:IsFacedown() then
		return
	end
	
	if Duel.Equip(tp,c,tc) then
		--Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		e1:SetLabelObject(tc)
		c:RegisterEffect(e1)
		
		--ATK/DEF increase
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e3)
	end
end

--Equip limit
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end