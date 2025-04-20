--艺形虫 当代L-C-17
local s,id,o=GetID()
--string
s.named_with_ArtlienWorm=1
--string check
function s.ArtlienWorm(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ArtlienWorm
end
--
function s.initial_effect(c)
	--link summon
	s.AddLinkProcedure(c,nil,2,3,s.lcheck)
	c:EnableReviveLimit()
	--avoid
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.adcon)
	e1:SetOperation(s.adop)
	c:RegisterEffect(e1)
	--tp grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	aux.RegisterMergedDelayedEvent(c,id,EVENT_SPSUMMON_SUCCESS)
end
function s.lcheck(g,lc)
	return g:IsExists(s.ArtlienWorm,1,nil)
end
function s.adcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c==Duel.GetAttacker() or c==Duel.GetAttackTarget()) and Duel.GetBattleDamage(tp)>0 and Duel.IsPlayerCanRemove(tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
end
function s.adop(e,tp,eg,ep,ev,re,r,rp)
	local ct=math.ceil(Duel.GetBattleDamage(tp)/200)
	if ct>Duel.GetFieldGroupCount(tp,0,LOCATION_DECK) then ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK) end
	local g=Duel.GetDecktopGroup(1-tp,ct)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function s.tgfilter(c,g,tp)
	return g:IsContains(c) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(s.tgfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c)
end
function s.tgfilter2(c,g,tp)
	return s.ArtlienWorm(c) and c:IsFaceupEx() and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,eg,tp) end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local check=false
	if Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,eg,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,eg,tp):GetFirst()
		local sc=Duel.SelectMatchingCard(tp,s.tgfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,tc):GetFirst()
		local g=Group.FromCards(tc,sc)
		Duel.HintSelection(g)
		if Duel.SendtoGrave(g,REASON_EFFECT)~=2 or g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)~=2 then check=true end
	else check=true end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and check and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

---Link Summon
---@param c Card
---@param f function|nil
---@param min integer
---@param max? integer
---@param gf? function
---@return Effect
function s.AddLinkProcedure(c,f,min,max,gf)
	if max==nil then max=c:GetLink() end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.LinkCondition(f,min,max,gf))
	e1:SetTarget(s.LinkTarget(f,min,max,gf))
	e1:SetOperation(s.LinkOperation(f,min,max,gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	return e1
end
function s.LConditionFilter(c,f,lc,e)
	return (c:IsFaceup() or not c:IsOnField() or e:IsHasProperty(EFFECT_FLAG_SET_AVAILABLE))
		and c:IsCanBeLinkMaterial(lc) and (not f or f(c))
end
function s.LExtraFilter(c,f,lc,tp)
	if c:IsOnField() and c:IsFacedown() then return false end
	if not c:IsCanBeLinkMaterial(lc) or f and not f(c) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do
		local tf=te:GetValue()
		local related,valid=tf(te,lc,nil,c,tp)
		if related then return true end
	end
	return false
end
function s.GetLinkCount(c)
	if c:IsLinkType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else return 1 end
end
function s.LinkMaterialFilterExtra(c,f,lc)
	if not c:IsCanBeLinkMaterial(lc) or f and not f(c) then return false end
	return s.ArtlienWorm(c)
end
function s.GetLinkMaterials(tp,f,lc,e)
	local mg=Duel.GetMatchingGroup(s.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc,e)
	local mg2=Duel.GetMatchingGroup(s.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	if Duel.GetFlagEffect(tp,id)==0 then
		local mg3=Duel.GetMatchingGroup(s.LinkMaterialFilterExtra,tp,LOCATION_HAND,0,nil,f,lc)
		if mg3:GetCount()>0 then mg:Merge(mg3) end
	end
	return mg
end
function s.LCheckOtherMaterial(c,mg,lc,tp)
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	local res1=false
	local res2=true
	for _,te in pairs(le) do
		local f=te:GetValue()
		local related,valid=f(te,lc,mg,c,tp)
		if related then res2=false end
		if related and valid then res1=true end
	end
	return res1 or res2
end
function s.LUncompatibilityFilter(c,sg,lc,tp)
	local mg=sg:Filter(aux.TRUE,c)
	return not s.LCheckOtherMaterial(c,mg,lc,tp)
end
function s.LCheckGoal(sg,tp,lc,gf,lmat)
	return sg:CheckWithSumEqual(s.GetLinkCount,lc:GetLink(),#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg,lc,tp))
		and not sg:IsExists(s.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function s.LExtraMaterialCount(mg,lc,tp)
	for tc in aux.Next(mg) do
		local le={tc:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
		local Not_LExtra=true
		for _,te in pairs(le) do
			local sg=mg:Filter(s.TRUE,tc)
			local f=te:GetValue()
			local related,valid=f(te,lc,sg,tc,tp)
			if related and valid then
				te:UseCountLimit(tp)
				Not_LExtra=false
			end
		end
		if Not_LExtra and tc:IsLocation(LOCATION_HAND) then
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(lc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e1:SetTargetRange(1,0)
			e1:SetDescription(aux.Stringid(id,3))
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end 
	end
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
					mg=og:Filter(s.LConditionFilter,nil,f,c,e)
				else
					mg=s.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not s.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(s.LCheckGoal,minc,maxc,tp,c,gf,lmat)
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
					mg=og:Filter(s.LConditionFilter,nil,f,c,e)
				else
					mg=s.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not s.LConditionFilter(lmat,f,c,e) then return false end
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
function s.HandLinkFilter(c,tp)
	if not c:IsLocation(LOCATION_HAND) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	return le 
end
function s.LinkOperation(f,minct,maxct,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				s.LExtraMaterialCount(g,c,tp)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end
