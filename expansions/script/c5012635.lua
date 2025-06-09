--阿拉迪娅
local s,id,o=GetID()
s.MoJin=true
s.Max=3
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(s.linkfilter,c),0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.LinkCondition(aux.FilterBoolFunction(s.linkfilter),s.Max,s.Max))
	e1:SetTarget(s.LinkTarget(aux.FilterBoolFunction(s.linkfilter),s.Max,s.Max))
	e1:SetOperation(s.LinkOperation(aux.FilterBoolFunction(s.linkfilter),s.Max,s.Max))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(s.desreptg)
	e2:SetOperation(s.desrepop)
	c:RegisterEffect(e2)
	--battle
	local eb1=Effect.CreateEffect(c)
	eb1:SetType(EFFECT_TYPE_SINGLE)
	eb1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	eb1:SetValue(1)
	c:RegisterEffect(eb1)
	--double
	local eb2=Effect.CreateEffect(c)
	eb2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	eb2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	eb2:SetRange(LOCATION_MZONE)
	eb2:SetTargetRange(LOCATION_MZONE,0)
	eb2:SetCondition(s.rdcon)
	eb2:SetOperation(s.rdop)
	c:RegisterEffect(eb2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(s.reop)
	c:RegisterEffect(e3)
	--des
	local ed1=Effect.CreateEffect(c)
	ed1:SetDescription(aux.Stringid(id,1))
	ed1:SetCategory(CATEGORY_DESTROY)
	ed1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ed1:SetCode(EVENT_SPSUMMON_SUCCESS)
	ed1:SetRange(LOCATION_MZONE)
	ed1:SetTarget(s.destg)
	ed1:SetOperation(s.desop)
	c:RegisterEffect(ed1)
	local ed2=ed1:Clone()
	ed2:SetCode(EVENT_ATTACK_ANNOUNCE)
	c:RegisterEffect(ed2)
	local ed3=ed1:Clone()
	ed3:SetCode(EVENT_BECOME_TARGET)
	c:RegisterEffect(ed3)
	local ed4=ed1:Clone()
	ed4:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(ed4)

	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.chk)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.LCheckGoal(sg,tp,lc,gf,lmat,max)
	return sg:CheckWithSumEqual(s.GetLinkCount,max,#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg,lc,tp))
		and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function s.GetLinkCount(c)
	return 1
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
				if s.Max<3 then
					minc=s.Max
					maxc=s.Max
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(s.LCheckGoal,minc,maxc,tp,c,gf,lmat,maxc)
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
				if s.Max<3 then
					minc=s.Max
					maxc=s.Max
				end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,s.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat,maxc)
				if s.Max>0 then
					if sg then
						sg:KeepAlive()
						e:SetLabelObject(sg)
						return true
					else return false end
				elseif s.Max==0 then
					e:SetLabelObject(nil)
					return true
				end
			end
end
function s.LinkOperation(f,minct,maxct,gf)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				if g then
					c:SetMaterial(g)
					Auxiliary.LExtraMaterialCount(g,c,tp)
					Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
					g:DeleteGroup()
				elseif g==nil then
				end
			end
end

function s.chkfilter(c)
	return c:IsCode(5012604) and c:IsPosition(POS_FACEUP)
end
function s.chk(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if s.chkfilter(tc) and s.Max>0 then
			s.Max=s.Max-1
		end
		tc=eg:GetNext()
	end
end
function s.linkfilter(c)
	return c:IsCanBeLinkMaterial(nil) and c.MoJin
end
function s.repfilter(c)
	return not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_EXTRA,1,c)
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		local g=c:GetEquipGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=Duel.SelectMatchingCard(tp,s.repfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_EXTRA,1,1,c)
		Duel.SetTargetCard(sg)
		return true
	else return false end
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
function s.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep==1-tp and tc==e:GetHandler()
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(1-tp,ev*3)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	s.Max=3
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,3,1,nil,LOCATION_ONFIELD)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,nil) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,3,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
