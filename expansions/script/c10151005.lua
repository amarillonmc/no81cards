--昆虫皇后
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10151005)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_INSECT),2)
	local e1=rsef.FV_UPDATE(c,"atk",cm.val,aux.TargetBoolFunction(Card.IsRace,RACE_INSECT),{LOCATION_MZONE,0})
	local e2=rsef.FTF(c,EVENT_LEAVE_FIELD,{m,0},nil,"tk,sp",nil,LOCATION_MZONE,cm.tkcon,nil,cm.tktg,cm.tkop)
end
function cm.val(e,c)
	return Duel.GetMatchingGroupCount(rscf.fufilter(Card.IsRace,RACE_INSECT),0,LOCATION_MZONE,LOCATION_MZONE,nil)*200
end
function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()~=tp
end
function cm.tkcon(e,tp,eg)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,91512836,0,0x4011,100,100,1,RACE_INSECT,ATTRIBUTE_EARTH,POS_FACEUP_ATTACK,1-tp) then return end
	local token=Duel.CreateToken(tp,91512836)
	if Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)<=0 then return end
	local e1=rsef.SC({c,token,true},EVENT_BE_MATERIAL,{m,1},nil,"ch,ep",cm.matcon,cm.matop)
end
function cm.matcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return rc:GetSummonType()&SUMMON_TYPE_FUSION + SUMMON_TYPE_SYNCHRO + SUMMON_TYPE_LINK ~=0 
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1,e2,e3,e4,e5=rscf.QuickBuff({c,rc,true},"dis,dise,ress~,resns~",1,"race",RACE_INSECT)
end