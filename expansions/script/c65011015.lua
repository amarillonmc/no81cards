--以斯拉的领主 涅塔尼亚胡
if not pcall(function() require("expansions/script/c65011001") end) then require("script/c65011001") end
local m,cm=rscf.DefineCard(65011015,"Israel")
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--link
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.LinkCondition(cm.lfilter,1,5))
	e0:SetTarget(cm.LinkTarget(cm.lfilter,1,5))
	e0:SetOperation(Auxiliary.LinkOperation(cm.lfilter,1,5))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.regcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	--act 
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,"act",nil,nil,"de",rscon.sumtype("link"),nil,rsop.target(cm.actfilter,nil,LOCATION_DECK),cm.actop)
	if cm.switch then return end
	cm.switch = true
	local ge1=rsef.FC({c,0},EVENT_SPSUMMON_SUCCESS)
	ge1:SetOperation(cm.regop2)
end
function cm.actfilter(c,e,tp)
	return rsisr.IsSet(c) and c:IsType(TYPE_CONTINUOUS) and c:GetActivateEffect():IsActivatable(tp,true,true) and e:GetHandler():GetLinkedGroupCount()>0
end
function cm.actop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	if not c then return end
	local ct=c:GetLinkedGroupCount()
	if ct==0 then return end 
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	ct = math.min(ft,ct)
	rsop.SelectSolve("act",tp,cm.actfilter,tp,LOCATION_DECK,0,1,ct,nil,cm.actfun,e,tp)
end
function cm.actfun(g,e,tp)
	for tc in aux.Next(g) do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end 
	end
	return true
end
function cm.regop2(e,tp,eg)
	for p=0,1 do 
		if eg:IsExists(cm.spcfilter,1,nil,p) and Duel.GetFlagEffect(1-p,m)<4 then
			Duel.RegisterFlagEffect(1-p,m,rsreset.pend,0,1)
		end
	end
end
function cm.spcfilter(c,p)
	return c:IsFaceup() and rsisr.IsSet(c) and c:GetSummonPlayer()==p
end
function cm.lfilter(c)
	return rsisr.IsLinkSet(c) and not c:IsLinkType(TYPE_LINK)
end
function cm.LinkCondition(f,minc,maxc,gf)
	return  function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc-Duel.GetFlagEffect(tp,m)
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c) then return false end
					mg:AddCard(lmat)
				end
				local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(cm.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function cm.LCheckGoal(sg,tp,lc,gf,lmat)
	return sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink()-Duel.GetFlagEffect(tp,m),#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
		and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function cm.LinkTarget(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minc
				local maxc=maxc-Duel.GetFlagEffect(tp,m)
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c) then return false end
					mg:AddCard(lmat)
				end
				local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,cm.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(m) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end